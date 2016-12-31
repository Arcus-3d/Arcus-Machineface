import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import QtQml 2.2
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0

ApplicationItem {
    property var numberModel: defaultHandler.incrementsModel //numberModelBase.concat(["inf"])
    property var numberModelReverse: defaultHandler.incrementsModelReverse
    property var axisColors: ["#F5A9A9", "#A9F5F2", "#81F781", "#D2B48C", "#D28ED0", "#CFCC67"]
    property color allColor: "#DDD"
    property color specialColor: "#BBBBBB"
    property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"] // should come from INI/config
    property string eName: "E"
    property string eUnits: "mm/s"
    property bool zVisible: status.synced ? status.config.axes > 2 : true
    property bool aVisible: status.synced ? status.config.axes > 3 : true
    property bool eVisible: halRemoteComponent.connected || eWasConnected
    property bool eWasConnected: false
    property bool eEnabled: halRemoteComponent.connected
    property int buttonBaseHeight: container.height / (numberModel.length*2+1)

    property int baseSize: Math.min(width, height)
    property int fontSize: baseSize * 0.028

    id: root

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: "fdm-ve-jog"
        containerItem: extruderControl
        create: false
        onErrorStringChanged: console.log(errorString)
        onConnectedChanged: root.eWasConnected = true
    }

    JogDistanceHandler {
        id: defaultHandler
        continuousText: "inf"
        core: root.core
        axis: -1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        visible: root.status.synced

        Item {
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: Math.min(width / 1.6, parent.height)

            Item {
                id: mainItem
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                Layout.fillWidth: true
                JogDistanceHandler {
                    property int buttonBaseSize: container.height / (incrementsModel.length*2+1)

                    id: xyHandler
                    continuousText: "inf"
                    core: root.core
                    axis: 0
                }

                ColumnLayout {
                    id: buttonActionLayout
                    anchors.top: homeButton.bottom
                    anchors.bottom: feedRateKnob.top
                    Layout.fillWidth: true
                    anchors.left: parent.left
                Button {
                    Layout.fillWidth: true
                    text: "G0 Z0"
                    enabled: true
                    tooltip: ""
                    onClicked: actionOne.trigger()
                    MdiCommandAction {
                        id: actionOne
                        mdiCommand: "G0 Z0"
                        enableHistory: false
                    }
                }
                Button {
                    Layout.fillWidth: true
                    text: "G0 Z5"
                    enabled: true
                    tooltip: ""
                    onClicked: actionTwo.trigger()
                    MdiCommandAction {
                        id: actionTwo
                        mdiCommand: "G0 Z5"
                        enableHistory: false
                    }
                }
                Button {
                    Layout.fillWidth: true
                    text: "G0 Z300"
                    enabled: true
                    tooltip: ""
                    onClicked: actionThree.trigger()
                    MdiCommandAction {
                        id: actionThree
                        mdiCommand: "G0 Z300"
                        enableHistory: false
                    }
                }
		}
                HomeButton {
                    id: homeButton
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.height * 0.3
                    height: width
                    axis: -1
                    axisName: "All"
                    color: "white"
                    fontSize: root.fontSize
                }
                JogKnob {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.3
                    height: width
                id: feedrateKnob
                minimumValue: feedrateHandler.minimumValue
                maximumValue: feedrateHandler.maximumValue
                defaultValue: 1.0
                enabled: feedrateHandler.enabled
                color: allColor
                axisName: ""
                font.pixelSize: root.fontSize
                stepSize: 0.05
                decimals: 2
                text: (value * 100).toFixed(0) + "%"

                FeedrateHandler {
                    id: feedrateHandler
                }

                Binding { target: feedrateKnob; property: "value"; value: feedrateHandler.value }
                Binding { target: feedrateHandler; property: "value"; value: feedrateKnob.value }
            }
            }

            Item {
                property int axisIndex: status.synced ? status.config.axes : 0
                property double extruderVelocity: 5.0

                id: extruderControl
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: parent.height * 0.03
                width: parent.height * 0.30
                visible: eVisible
                enabled: eEnabled

                HalPin {
                    id: jogVelocityPin
                    name: "velocity"
                    direction: HalPin.IO
                    type: HalPin.Float
                }

                HalPin {
                    id: jogDistancePin
                    name: "distance"
                    direction: HalPin.IO
                    type: HalPin.Float
                }

                HalPin {
                    id: jogDirectionPin
                    name: "direction"
                    direction: HalPin.IO
                    type: HalPin.Bit
                }

                HalPin {
                    id: jogTriggerPin
                    name: "trigger"
                    direction: HalPin.IO
                    type: HalPin.Bit
                }

                HalPin {
                    id: jogContinuousPin
                    name: "continuous"
                    direction: HalPin.IO
                    type: HalPin.Bit
                }

                HalPin {
                    id: jogDtgPin
                    name: "dtg"
                    direction: HalPin.In
                    type: HalPin.Float
                }

                HalPin {
                    id: jogMaxVelocityPin
                    name: "max-velocity"
                    direction: HalPin.In
                    type: HalPin.Float
                }

                HalPin {
                    id: jogExtruderCountPin
                    name: "extruder-count"
                    direction: HalPin.In
                    type: HalPin.U32
                }

                HalPin {
                    id: jogExtruderSelPin
                    name: "extruder-sel"
                    direction: HalPin.In
                    type: HalPin.S32
                }
                ColumnLayout {
                    id: extruderTopLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.width

                    ExtruderJogButton {
                        Layout.preferredWidth: parent.width
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter
                        distance: 0
                        direction: true
                        enabled: homeXButton.enabled && !jogTriggerPin.value
                                 && (!jogContinuousPin.value || (distance == 0 && jogDirectionPin.value))
                        text: ""
                        style: CustomStyle {
                            baseColor: axisColors[extruderControl.axisIndex];
                            darkness: 3*0.06
                            fontSize: root.fontSize
                            fontIcon: "\ue316"
                            fontIconSize: root.fontSize * 2.5
                        }
                    }
                    ExtruderJogButton {
                        Layout.preferredWidth: parent.width
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter
                        distance: 0
                        direction: false
                        enabled: homeXButton.enabled && !jogTriggerPin.value
                                 && (!jogContinuousPin.value || (distance == 0 && jogDirectionPin.value))
                        text: ""
                        style: CustomStyle {
                            baseColor: axisColors[extruderControl.axisIndex];
                            darkness: 3*0.06
                            fontSize: root.fontSize
                            fontIcon: "\ue313"
                            fontIconSize: root.fontSize * 2.5
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                    }
            	    JogKnob {
              	        id: jogVelocityKnob
              	        height: parent.width
              	        Layout.preferredWidth: height
              	        visible: eVisible
              	        enabled: eEnabled
              	        minimumValue: 1
              	        maximumValue: jogMaxVelocityPin.value
              	        defaultValue: 3.0
              	        color: axisColors[extruderControl.axisIndex]
                	axisName: eName + jogExtruderSelPin.value
              	        font.pixelSize: root.fontSize
        	        Binding { target: jogVelocityPin; property: "value"; value: jogVelocityKnob.value }
               	        Binding { target: jogVelocityKnob; property: "value"; value: jogVelocityPin.value }
            	    }
                }
            }
        }
    }
}
