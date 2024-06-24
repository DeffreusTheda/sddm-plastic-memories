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

Label {
	text: "Terminate this Program?"
	color: "#fcfdfc"
	font.bold: true
	font.family: config.font
	font.pixelSize : 16

	verticalAlignment: Text.AlignVCenter
	horizontalAlignment: Text.AlignHCenter
}
