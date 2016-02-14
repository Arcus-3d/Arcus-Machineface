import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

ColumnLayout {
    Layout.fillWidth: true
    Repeater {
        model: 6
        WeightControl {
            componentName: "fdm-ew" + index
            labelName: "Filament " + (index + 1)
        }
    }


    Item {
        Layout.fillHeight: true
    }
}
