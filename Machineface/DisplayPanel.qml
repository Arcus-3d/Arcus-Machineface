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
    DigitalReadOut {
        Layout.fillWidth: true
    }

    TemperatureControl {
        componentName: "fdm-hbp"
        labelName: "Heated Bed"
        logHeight: parent.height * 0.25
    }

    TemperatureControl {
        componentName: "fdm-hbc"
        labelName: "Heated Chamber"
        logHeight: parent.height * 0.25
    }

    TemperatureControl {
        componentName: "fdm-e0"
        labelName: "Extruder"
    }

    Repeater {
        model: 6
        WeightControl {
            componentName: "fdm-ew" + index
            labelName: "Filament " + (index + 1)
        }
    }

    WeightControl {
        componentName: "fdm-m0"
        labelName: "Mixer"
    }

    Repeater {
        model: 10
        FanControl {
            componentName: "fdm-f" + index
            labelName: "Fan " + (index + 1)
        }
    }

    WeightControl {
        componentName: "fdm-c0"
        labelName: "Cooling"
    }


    Repeater {
        model: 3
        LightControl {
            componentName: "fdm-l" + index
            labelName: "Light " + (index + 1)
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
