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
        labelName: "Bed Temp"
        logHeight: parent.height * 0.25
    }

    TemperatureControl {
        componentName: "fdm-e0"
        labelName: "Extruder Temp"
        logHeight: parent.height * 0.25
    }
    Repeater {
        model: 6
        WeightControl {
            componentName: "fdm-ew" + index
            labelName: "Extruder " + index + " Weight"
        	logHeight: parent.height * 0.25
        }
    }
    
    WeightControl {
        componentName: "fdm-m0"
        labelName: "Mixer Speed"
       	logHeight: parent.height * 0.25
    }

    FanControl {
        componentName: "fdm-f0"
        labelName: "Fan Speed"
       	logHeight: parent.height * 0.25
    }

    WeightControl {
        componentName: "fdm-c0"
        labelName: "Cooling Pump Speed"
       	logHeight: parent.height * 0.25
    }

    Item {
        Layout.fillHeight: true
    }
}
