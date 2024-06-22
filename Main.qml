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
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import QtMultimedia 5.5
import SddmComponents 2.0

Rectangle {
	color: "black"
	width: Window.width
	height: Window.height

	//: Buildup timers
	Timer {
		interval: if (config.buildup == "false") 0; else 12680
		running: true
		onTriggered: {
			centerColumn.visible = true
			shutdownBtn.visible = true
			rebootBtn.visible = true
			session.visible = true
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
		source: "ring-of-fortune.webm"
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

	ColumnLayout {
		id: centerColumn
		visible: false
		width: parent.width
		height: parent.height

		Image {
			id: title
			source: if (config.titleLanguage == "English") "title-english.png"; else "title.png"
			visible: true
			opacity: 0

			Layout.alignment: Qt.AlignTop
			Layout.preferredWidth: Window.width * 0.75
			Layout.preferredHeight: Window.height * 0.75
			fillMode: Image.PreserveAspectFit
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Label {
			color: "#fcfdfc"
			font.family: config.font
			font.pixelSize: 24
			font.bold: true
			property variant messages: [
				userModel.lastUser + "... Do you... want... me?",
				userModel.lastUser + "... Your smile looks good",
				"Welcome home... " + userModel.lastUser
			]
			property var index: (Math.random() * messages.length).toFixed(0)
			text: "Welcome home... Deffreus Theda"

			Layout.alignment: Qt.AlignCenter
			Layout.bottomMargin: 20
			height: 50
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

			KeyNavigation.backtab: shutdownBtn; KeyNavigation.tab: password
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
	AnimatedImage {
		id: shutdownBtn
		source: "terminate-icon.png"
		visible: false
		height: 40
		fillMode: Image.PreserveAspectFit

		y: 20
		x: Window.width - width - 20

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.powerOff()
			property var tooltip
			onExited: tooltip.destroy(0)
			onEntered: {
				var component = Qt.createComponent("ShutdownToolTip.qml");
				if (component.status == Component.Ready) {
					tooltip = component.createObject(shutdownBtn);
					tooltip.x = shutdownBtn.width - tooltip.width
					tooltip.y = shutdownBtn.y + shutdownBtn.height
				}
			}
		}
	}

	AnimatedImage {
		id: rebootBtn
		source: "sai-icon.png"
		visible: false
		height: shutdownBtn.height
		fillMode: Image.PreserveAspectFit

		y: shutdownBtn.y
		anchors.right: shutdownBtn.left
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
					tooltip = component.createObject(rebootBtn)
					tooltip.x = (rebootBtn.width - tooltip.width) / 2
					tooltip.y = rebootBtn.y + rebootBtn.height
				}
			}
		}
	}

	ComboBox {
		id: session
		visible: false
		height: 30
		width: 200
		font.family: config.font
		x: 20
		y: 20
		model: sessionModel
		index: sessionModel.lastIndex
		color: "#fcfdfc"
		borderColor: "#016ccc"
		focusColor: "#fc4b58"
		textColor: "#3c3635"
		arrowIcon: "arrow-icon.png"
		KeyNavigation.backtab: password; KeyNavigation.tab: rebootBtn;
	}

	Component.onCompleted: {
		if (username.text == "") {
			username.focus = true
		} else {
			password.focus = true
		}
	}
}

