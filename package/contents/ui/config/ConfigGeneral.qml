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
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.iconthemes as KIconThemes
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

Kirigami.FormLayout {
    id: page

    property string cfg_icon: Plasmoid.configuration.icon
    readonly property string cfg_iconDefault: Plasmoid.configuration.icon.default
    property alias cfg_menuLabel: menuLabel.text
    property alias cfg_showHidden: showHidden.checked
    property alias cfg_showDevices: showDevices.checked
    property alias cfg_showTimeline: showTimeline.checked
    property alias cfg_showSearches: showSearches.checked
    property alias cfg_widgetWidth: widgetWidth.value

    property var mediumSpacing: 1.5 * Kirigami.Units.smallSpacing

    Button {
        id: iconButton

        Kirigami.FormData.label: i18n('Icon:')

        implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
        implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2
        hoverEnabled: true

        ToolTip.delay: Kirigami.Units.toolTipDelay
        ToolTip.text: i18nc('@info:tooltip', 'Icon name is "%1"', page.cfg_icon)
        ToolTip.visible: iconButton.hovered && page.cfg_icon.length > 0

        KIconThemes.IconDialog {
            id: iconDialog
            onIconNameChanged: {
                page.cfg_icon = iconName || cfg_iconDefault;
            }
        }

        onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

        KSvg.FrameSvgItem {
            id: previewFrame
            anchors.centerIn: parent
            imagePath: Plasmoid.formFactor === PlasmaCore.Types.Vertical || Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                    ? 'widgets/panel-background' : 'widgets/background'
            width: Kirigami.Units.iconSizes.medium + fixedMargins.left + fixedMargins.right
            height: Kirigami.Units.iconSizes.medium + fixedMargins.top + fixedMargins.bottom

            Kirigami.Icon {
                anchors.centerIn: parent
                width: Kirigami.Units.iconSizes.medium
                height: width
                source: page.cfg_icon
            }
        }

        Menu {
            id: iconMenu

            // Appear below the button
            y: parent.height

            MenuItem {
                text: i18nc('@item:inmenu Open icon chooser dialog', 'Choose…')
                icon.name: 'document-open-folder'
                Accessible.description: i18nc('@info:whatsthis', 'Choose an icon for Application Launcher')
                onClicked: iconDialog.open()
            }
            MenuItem {
                text: i18nc('@item:inmenu Reset icon to default', 'Reset to default icon')
                icon.name: 'edit-clear'
                enabled: page.cfg_icon !== cfg_iconDefault
                onClicked: page.cfg_icon = cfg_iconDefault
            }
            MenuItem {
                text: i18nc('@action:inmenu', 'Remove icon')
                icon.name: 'delete'
                enabled: page.cfg_icon !== '' && menuLabel.text && Plasmoid.formFactor !== PlasmaCore.Types.Vertical
                onClicked: page.cfg_icon = ''
            }
        }
    }

    Kirigami.ActionTextField {
        id: menuLabel
        Kirigami.FormData.label: i18nc('@label:textbox', 'Text label:')
        text: Plasmoid.configuration.menuLabel
        placeholderText: i18nc('@info:placeholder', 'Type here to add a text label')
        onTextEdited: {
            // This is to make sure that we always have a icon if there is no text.
            // If the user remove the icon and remove the text, without this, we'll have no icon and no text.
            // This is to force the icon to be there.
            if (!menuLabel.text) {
                page.cfg_icon = page.cfg_icon || cfg_iconDefault
            }
        }
        rightActions: Action {
            icon.name: 'edit-clear'
            enabled: menuLabel.text !== ''
            text: i18nc('@action:button', 'Reset menu label')
            onTriggered: {
                menuLabel.clear()
                page.cfg_icon = page.cfg_icon || cfg_iconDefault
            }
        }
    }

    CheckBox {
        id: showHidden
        Kirigami.FormData.label: i18n('Places:')
        text: i18n('Show hidden places')
        Layout.columnSpan: 2
    }

    CheckBox {
        id: showDevices
        text: i18n('Show devices')
        Layout.columnSpan: 2
    }

    CheckBox {
        id: showTimeline
        text: i18n('Show recently used')
        Layout.columnSpan: 2
    }

    CheckBox {
        id: showSearches
        text: i18n('Show searches')
        Layout.columnSpan: 2
    }

    SpinBox {
        id: widgetWidth
        Kirigami.FormData.label: i18n('Widget width:')
        from: Kirigami.Units.iconSizes.medium + 2 * mediumSpacing
        to: 1000
        stepSize: 10
        textFromValue: function(value) { return value + ' px'; }
        valueFromText: function(text) { return Number(text.remove(RegExp(' px$'))); }
    }
}
