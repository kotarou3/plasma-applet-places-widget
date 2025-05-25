/*
 * Copyright 2016  Daniel Faust <hessijames@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: plasmoidItem
    property string icon: plasmoid.configuration.icon
    property string menuLabel: plasmoid.configuration.menuLabel
    property bool showHidden: plasmoid.configuration.showHidden
    property bool showDevices: plasmoid.configuration.showDevices
    property bool showTimeline: plasmoid.configuration.showTimeline
    property bool showSearches: plasmoid.configuration.showSearches
    property int widgetWidth: plasmoid.configuration.widgetWidth
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    /*compactRepresentation: MouseArea {
        id: mouseArea
        Layout.minimumHeight: parent.height
        Layout.minimumWidth: childrenRect.width
        Layout.preferredHeight: Layout.minimumHeight
        Layout.preferredWidth: Layout.minimumWidth

        onClicked: plasmoidItem.expanded = !plasmoidItem.expanded
        hoverEnabled: true

        Row {
            id: row
            height: parent.height
            width: childrenRect.width
            anchors.centerIn: parent
            spacing: 0

            Kirigami.Icon {
                source: icon
                height: parent.height
                width: Math.min(height, Kirigami.Units.iconSizes.medium)
                active: mouseArea.containsMouse
                visible: valid
            }
            Label {
                text: menuLabel
                height: parent.height
                //width: contentWidth
                leftPadding: Kirigami.Units.smallSpacing
                rightPadding: Kirigami.Units.smallSpacing

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.VerticalFit
                font.pixelSize: Kirigami.Units.iconSizes.roundedIconSize(Kirigami.Units.gridSize * 2)
                visible: menuLabel !== ""
            }
        }
    }*/
    compactRepresentation: MouseArea {
        id: compactRoot

        // Taken from DigitalClock to ensure uniform sizing when next to each other
        readonly property bool tooSmall: !vertical && Math.round(2 * (compactRoot.height / 5)) <= Kirigami.Theme.smallFont.pixelSize

        readonly property int iconSize: Kirigami.Units.iconSizes.medium

        readonly property var sizing: {
            let impWidth = 0;
            if (buttonIcon.valid) {
                impWidth += buttonIcon.width;
            }
            if (menuLabel !== '') {
                impWidth += labelTextField.contentWidth + labelTextField.Layout.leftMargin + labelTextField.Layout.rightMargin;
            }
            const impHeight = buttonIcon.height > 0 ? buttonIcon.height : iconSize

            // at least square, but can be wider/taller
            if (vertical) {
                return {
                    preferredWidth: iconSize,
                    preferredHeight: impHeight
                };
            } else { // horizontal
                return {
                    preferredWidth: impWidth,
                    preferredHeight: iconSize
                };
            }
        }

        implicitWidth: iconSize
        implicitHeight: iconSize

        Layout.preferredWidth: sizing.preferredWidth
        Layout.preferredHeight: sizing.preferredHeight
        Layout.minimumWidth: Layout.preferredWidth
        Layout.minimumHeight: Layout.preferredHeight

        hoverEnabled: true

        Accessible.name: Plasmoid.title
        Accessible.role: Accessible.Button

        property bool wasExpanded
        onPressed: wasExpanded = plasmoidItem.expanded
        onClicked: plasmoidItem.expanded = !wasExpanded

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Kirigami.Icon {
                id: buttonIcon

                Layout.fillWidth: vertical
                Layout.fillHeight: !vertical
                Layout.preferredWidth: vertical ? -1 : height / (implicitHeight / implicitWidth)
                Layout.preferredHeight: !vertical ? -1 : width * (implicitHeight / implicitWidth)
                Layout.maximumHeight: Kirigami.Units.iconSizes.medium
                Layout.maximumWidth: Kirigami.Units.iconSizes.medium
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                source: icon
                active: compactRoot.containsMouse
                roundToIconSize: implicitHeight === implicitWidth
                visible: valid
            }

            Label {
                id: labelTextField

                Layout.fillHeight: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing

                text: menuLabel
                textFormat: Text.StyledText
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                fontSizeMode: Text.VerticalFit
                font.pixelSize: compactRoot.tooSmall ? Kirigami.Theme.defaultFont.pixelSize : Kirigami.Units.iconSizes.roundedIconSize(Kirigami.Units.gridUnit * 2)
                minimumPointSize: Kirigami.Theme.smallFont.pointSize
                visible: menuLabel !== ''
            }
        }
    }

    fullRepresentation: FullRepresentation {}

    preferredRepresentation: compactRepresentation
}
