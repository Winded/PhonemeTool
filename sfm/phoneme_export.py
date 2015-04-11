import sfm
import json
from PySide import QtGui

def PresetGroupsToJSON():
    
    animSet = sfm.GetCurrentAnimationSet()
    presetGroups = animSet.presetGroups

    data = {}
    data["Model"] = str(animSet.gameModel.modelName)
    data["PresetGroups"] = []

    for presetGroup in presetGroups:

        pgdata = {}
        pgdata["Name"] = str(presetGroup.name)

        presets = []
        for preset in presetGroup.presets:
            pdata = {}
            pdata["Name"] = str(preset.name)
            controlValues = []
            for cv in preset.controlValues:
                cvdata = {}
                cvdata["Name"] = str(cv.name)
                if hasattr(cv, "value"):
                    cvdata["Value"] = str(cv.value)
                if hasattr(cv, "leftValue"):
                    cvdata["LeftValue"] = str(cv.leftValue)
                if hasattr(cv, "rightValue"):
                    cvdata["RightValue"] = str(cv.rightValue)
                controlValues.append(cvdata)
            pdata["ControlValues"] = controlValues
            presets.append(pdata)
        pgdata["Presets"] = presets

        data["PresetGroups"].append(pgdata)

    jdata = json.dumps(data)
    filename, _ = QtGui.QFileDialog.getSaveFileName(None, "Export preset groups", "C:\\" + str(animSet.name) + ".json")
    f = open(filename, "w")
    f.write(jdata)
    f.close()

    QtGui.QMessageBox.information(None, "Export successful", "Export succeeded! Export file: " + filename)

# Entry point
PresetGroupsToJSON()