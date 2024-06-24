/*
 *  Copyright (C) 2024  Deffreus Theda <thedadeffreus@gmail.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see https://www.gnu.org/licenses/.
 */

import QtQuick 2.15
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.5
import SddmComponents 2.0

Rectangle {
	color: "black"
	width: Window.width
	height: Window.height

	//: Buildup timers
	Timer {
		interval: config.buildup=="false" ? 0 : 12680
		running: true
		onTriggered: {
			centerColumn.visible = true
			shutdown.visible = true
			reboot.visible = true
			session.visible = 1
			clock.visible = config.clockEnabled==="false" ? false : true
		}
	}
	Timer {
		id: buildupTimer
		interval: 12680; running: true
		onTriggered: {
			title.opacity = 1
			titleLifespan.running = true
		}
	}
	//: Title lifespan
	Timer {
		id: titleLifespan
		// 77710 (Start -> Hide) - 12680 (Start -> Title)
		interval: 65030; running: false
		onTriggered: {
			title.opacity = 0
			titleDowntime.running = true
		}
	}
	//: Title downtime
	Timer {
		id: titleDowntime
		// 12680 (Start -> Title) + 91008 (Total Duration) - 77710 (Start -> Hide)
		interval: 25978; running: false
		onTriggered: {
			title.opacity = 1
			titleLifespan.running = true
		}
	}

	Connections {
		target: sddm
		onLoginSucceeded: { }
		onLoginFailed: { }
	}

	Video {
		id: openingVideo
		source: "ring-of-fortune.mp4"
		autoPlay: true

		width: Window.width
		height: Window.height
		fillMode: VideoOutput.PreserveAspectCrop

		muted: false
		volume: 0.25

		onStopped: {
			buildupTimer.running = true
			titleLifespan.running = false
			titleDowntime.running = false
			openingVideo.play()
		}
	}

	Column {
		id: clock
		visible: false
		spacing: 0
		x: password.Layout.bottomMargin
		y: Window.height - height - password.Layout.bottomMargin

		Label {
			id: timeClock
			anchors.horizontalCenter: parent.horizontalCenter
			font.bold: true
			font.family: config.font
			font.pointSize: 24
			color: "#fcfdfc"
			renderType: Text.QtRendering
			function updateTime() {
				text = new Date().toLocaleTimeString(Qt.locale(), config.timeFormat == "long" ? Locale.LongFormat : config.timeFormat !== "" ? config.timeFormat : Locale.ShortFormat)
			}
		}

		Label {
			id: dateClock
			anchors.horizontalCenter: parent.horizontalCenter
			font.bold: true
			font.family: config.font
			font.pointSize: 16
			color: "#fcfdfc"
			renderType: Text.QtRendering
			function updateTime() {
				text = new Date().toLocaleDateString(Qt.locale(), config.dateFormat == "short" ? Locale.ShortFormat : config.dateFormat !== "" ? config.dateFormat : Locale.LongFormat)
			}
		}

		Timer {
			interval: 1000
			repeat: true
			running: true
			onTriggered: {
				dateClock.updateTime()
				timeClock.updateTime()
			}
		}
		Component.onCompleted: {
			dateClock.updateTime()
			timeClock.updateTime()
		}
	}

	ColumnLayout {
		id: centerColumn
		visible: false
		width: parent.width
		height: parent.height

		Image {
			id: title
			source: config.titleLanguage==="English" ? "title-english.png" : "title.png"

			opacity: 0
			fillMode: Image.PreserveAspectFit

			Layout.alignment: Qt.AlignTop
			Layout.preferredWidth: Window.width * 0.75
			Layout.preferredHeight: Window.height * 0.75
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Label {
			id: welcome
			height: 50

			property variant messages: [
				"Welcome home... " + userModel.lastUser,
				userModel.lastUser + "... Do you... want... me?",
				userModel.lastUser + "... Your smile looks good"
			]
			property var random: (Math.random() * messages.length).toFixed(0)
			property var index: random===messages.length ? messages.length - 1 : random
			text: messages[index]

			color: "#fcfdfc"
			font.bold: true
			font.family: config.font
			font.pixelSize: 24

			Layout.alignment: Qt.AlignCenter
			Layout.bottomMargin: 20
		}

		TextField {
			id: username
			font.family: config.font
			text: userModel.lastUser
			placeholderText: config.usernamePlaceholder
			color: "#3c3635"
			background: Rectangle {
				color: "#fcfdfc"
				radius: 10
				implicitWidth: 200
				border.color: "#016ccc"
			}

			Layout.alignment: Qt.AlignHCenter

			KeyNavigation.backtab: shutdown; KeyNavigation.tab: password
			Keys.onPressed: {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}
		TextField {
			id: password
			font.family: config.font
			focus: true
			placeholderText: config.passwordPlaceholder
			echoMode: TextInput.Password
			passwordCharacter: "♡"
			passwordMaskDelay: config.passwordMaskDelay
			color: "#3c3635"
			background: Rectangle {
				color: "#fcfdfc"
				implicitWidth: 200
				radius: 10
				border.color: "#016ccc"
			}
		
			Layout.alignment: Qt.AlignHCenter
		Layout.bottomMargin: Window.height * 0.05
		
			KeyNavigation.backtab: username; KeyNavigation.tab: session
			Keys.onPressed: {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}
	}
	
	ComboBox {
		id: session
		visible: false
		model: sessionModel
		index: sessionModel.lastIndex

		width: 200
		height: ( username.height + password.height ) / 2
		x: 20
		y: 20

		font.bold: true
		font.family: config.font

		color: "#fcfdfc"
		borderColor: "#016ccc"
		focusColor: "#fc4b58"
		textColor: "#3c3635"
		arrowIcon: "arrow-icon.png"

		KeyNavigation.backtab: password; KeyNavigation.tab: reboot;
	}

	AnimatedImage {
		id: shutdown
		source: "terminate-icon.png"
		visible: false
		height: 50
		fillMode: Image.PreserveAspectFit

		y: Window.height - 2 * height
		x: Window.width - width - height

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.powerOff()
			property var tooltip
			onExited: tooltip.destroy(0)
			onEntered: {
				var component = Qt.createComponent("ShutdownToolTip.qml");
				if (component.status == Component.Ready) {
					tooltip = component.createObject(shutdown);
					tooltip.x = -tooltip.width + shutdown.width
					tooltip.y = -tooltip.height - 10
				}
			}
		}
	}

	AnimatedImage {
		id: reboot
		source: "sai-icon.png"
		visible: false
		height: shutdown.height
		fillMode: Image.PreserveAspectFit

		y: shutdown.y
		anchors.right: shutdown.left
		anchors.rightMargin: 20

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.reboot()
			property var tooltip
			onExited: tooltip.destroy(0)
			onEntered: {
				var component = Qt.createComponent("RebootToolTip.qml")
				if (component.status == Component.Ready) {
					tooltip = component.createObject(reboot)
					tooltip.x = ( reboot.width - tooltip.width ) / 2
					tooltip.y = -tooltip.height - 10
				}
			}
		}
	}

	Component.onCompleted: {
		if (username.text == "") {
			username.focus = true
		} else {
			password.focus = true
		}
	}
}

