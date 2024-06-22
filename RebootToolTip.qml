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

import QtQuick 2.5

Rectangle {
	color: "#fcfdfc"
	width: 110
	height: 32
	border.width: 1
	border.color: "#016ccc"
	property string label: "Replace OS?"
	Text {
		color: "#3c3635"
		font.pixelSize : 16
		text: parent.label
		anchors.fill: parent
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
	}
}
