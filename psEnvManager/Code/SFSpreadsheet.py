# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      SFSpreadsheet.py
#
# Purpose:   Helper Class.  All spreadsheet interactions are performed here
#
# History:
# Date        |  Author             | Action
#-------------+---------------------+----------------------------------------
# 31-Mar-2020 |  Ian Fickling       |  Version 1.0
# 06-May-2020 |  Ian Fickling       |  Added extra options for create DB
#             |                     |  DEFAULT_DDL_COLLATION
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
import os
import os.path
import datetime
from pandas import DataFrame, read_csv
import pandas as pd



class SFSpreadsheet:

    def __init__(self, sheetName = ""):
        self.dummy = ""
        self.sheetName = sheetName



    def readSpreadSheet(self, spreadsheetFile, sheetName):
        df = pd.read_excel(spreadsheetFile, sheet_name=sheetName)
        return df

    def getAdminRole(self, adminKey, dfConfig):
        adminRole = ""
        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == "ENVIRONMENT_ROLE" and str(rows['KEY']).upper() == adminKey.upper():
                adminRole = rows['VALUE']

        return adminRole

    def getKeyValue(self,  keyToFind, dfConfig):
        keyValue = ""

        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == keyToFind.upper():
                keyValue = rows['KEY']

        if type(keyValue) == bool and keyValue:
            keyValue = "TRUE"

        if type(keyValue) == bool and not keyValue:
            keyValue = "FALSE"


        if keyValue.upper() == "":
            keyValue = ""

        return keyValue

    def getPermissionType(self,  keyToFind, dfSheet):
        keyValue = ""

        for index, rows in dfSheet.iterrows():
            if str(rows['TYPE']).upper() == keyToFind.upper():
                keyValue = rows['OBJECT']

        if keyValue.upper() == "NONE":
            keyValue = ""

        return keyValue

    def getDataRetention(self, dfConfig):
        dataRetention = ""
        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == "DB_OPTION" and rows['KEY'].upper() == "DATA_RETENTION":
                dataRetention = str(rows['VALUE'])

        return dataRetention

    def getDDLCollation(self, dfConfig):
        ddlCoalation = ""
        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == "DB_OPTION" and rows['KEY'].upper() == "DEFAULT_DDL_COLLATION":
                ddlCoalation = str(rows['VALUE'])

        return ddlCoalation

    def getGrantOptions(self, dfConfig):
        grantOptions = {}
        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == "GRANT_OPTION":
                grantOptions[rows["KEY"]] = rows["VALUE"]

        return grantOptions

    def getSchemaPrivs(self, dfConfig):
        schemaPrivs = {}
        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == "SCHEMA_PRIVS":
                schemaPrivs[rows["KEY"]] = rows["VALUE"]

        return schemaPrivs

    def getWarehousePrivs(self, dfConfig):
        warehousePrivs = {}
        for index, rows in dfConfig.iterrows():
            if str(rows['TYPE']).upper() == "WAREHOUSE_PRIVS":
                warehousePrivs[rows["KEY"]] = rows["VALUE"]

        return warehousePrivs

    def getSchemas(self, dfSheet):
        schemaPrivs = []
        for index, rows in dfSheet.iterrows():
            if (str(rows['TYPE']).upper() == "SCHEMA") or (str(rows['TYPE']).upper() == "SCHEMA_O"):
                schemaPrivs.append(rows['OBJECT'])

        return schemaPrivs

    def getWarehouses(self, dbName, dfSheet):
        dictWarehouses = {}
        for index, rows in dfSheet.iterrows():
            if str(rows['TYPE']).upper() == 'WAREHOUSE':
                dictKey = dbName + "_" + rows['OBJECT']
                dictValue = rows['OPTIONS']
                dictWarehouses[dictKey] = dictValue

        return dictWarehouses
