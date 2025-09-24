# ********************************************************************************
# Legal:     This code is provided as is with no warranty .....
#
# File:      sfParams.py
#
# Purpose:   Helper Class.  Processes and validates command line arguments
#
# History:
# Date        |  Author             | Action
#-------------+---------------------+----------------------------------------
# 31-Mar-2020 |  Ian Fickling       |  Version 1.0
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
#             |                     |
import os
import os.path
from os import path
import pathlib
import getpass
import sys
import getopt
import logging

class SFParams:



    def __init__(self, opts, args, logger):
        self.snowflakeConnFile = ""
        self.spreadsheetFile = ""
        self.database = ""
        self.action = ""
        self.envTo = ""
        self.useraction = ""
        self.envFrom = ""
        self.outScript = ""
        self.runDDL = "FALSE"
        self.dbUserLogin = ""
        self.envOverrideName = ""
        self.userOverride = ""
        self.opts = opts
        self.args = args
        self.logger = logger
        self.tabName = ""
        self.include = "FALSE"  # include build security in build script
        try:

            #  relative pathnames must be resolved to full path names
            currentPath = str(pathlib.Path(__file__).parent.absolute())
            parentPath = str(pathlib.Path(__file__).parent.absolute().parent.absolute())

            for opt, arg in self.opts:
                if opt == "-c":
                    self.snowflakeConnFile = arg
                    if self.snowflakeConnFile[0:2] == "..":
                        self.snowflakeConnFile = parentPath + self.snowflakeConnFile[2:]
                    elif self.snowflakeConnFile[1] == ".":
                        self.snowflakeConnFile = currentPath + self.snowflakeConnFile[1:]
                elif opt == "-s":
                    self.spreadsheetFile = arg
                    if self.spreadsheetFile[0:2] == "..":
                        self.spreadsheetFile = parentPath + self.spreadsheetFile[2:]
                    elif self.spreadsheetFile[1] == ".":
                        self.spreadsheetFile = currentPath + self.spreadsheetFile[1:]
                elif opt == "-d":
                    self.database = arg
                elif opt == "-a":
                    self.action = arg
                elif opt == "-e":
                    self.envTo = arg
                elif opt == "-u":
                    self.useraction = arg
                elif opt == "-f":
                    self.envFrom = arg
                elif opt == "-o":
                    self.outScript = arg
                    if self.outScript[0:2] == "..":
                        self.outScript = parentPath + self.outScript[2:]
                    if self.outScript[1] == ".":
                        self.outScript = currentPath + self.outScript[1:]
                elif opt == "-r":
                    self.runDDL = arg
                elif opt == "-i":
                    self.include = arg
                elif opt == "-v":
                    self.envOverrideName = arg
                elif opt == "-t":
                    self.userOverride = arg

            self.tabName = self.envTo

            if self.envOverrideName != "":
                self.envTo = self.envOverrideName



        except getopt.GetoptError as e:
            self.logger.error("Invalid parameter(s): " + str(e))
            self.logger.error("Usage is: -")
            self.logger.error("   sfEnv  [-c <configFile> ] -s <spreadsheetFile> -a CLONE|NEW -e <dbEnv> [ -f <dbenv2> ] [-o <outscript>] [-r] [-u]")
            sys.exit(2)

    def validate(self):
        # Spreadsheet must be specified
        if self.spreadsheetFile == "" and not self.action == "DESTROY":
            self.logger.error("Parameter (-s | --spreadsheet=) is missing and must be specified" )
            return -1

        # Given the spreadsheet is specified, check it exist
        if not self.action == "DESTROY" and not os.path.isfile(self.spreadsheetFile):
            self.logger.error("Spreadsheet file: " + self.spreadsheetFile + " does not exist")
            return -1

        #if self.action.upper().find("NEW") == -1 and self.action.upper().find("CLONE") == -1 and \
        #        self.action.upper().find("REFRESH") == -1 and self.action.upper().find("VERIFY") == -1 and \
        #        self.action.upper().find("NEWSEC") == -1 and self.action.upper().find("DESTROY") == -1 and \
        #        self.action.upper().find("USER") == -1:
        #    self.logger.error("Parameter (-a | --action=) incorrect option (" + self.action + " is invalid. Must be USER NEW, CLONE, REFRESH, VERIFY, DESTROY or NEWSEC")
        #    return -1

        # specify allowed paramater for -u

        # An environment
        if self.envTo == "":
            self.logger.error("Parameter (-e | --env=) is missing and must be specified" )
            return -1

        # if a config file has been specified, check it exists
        if not self.snowflakeConnFile == "" and not os.path.isfile(self.snowflakeConnFile):
            self.logger.error("Config file: " + self.snowflakeConnFile + " does not exist")
            return -1

        # if -r (run script) is not specified, then the output script must be
        if self.runDDL.upper() == "FALSE" and self.outScript == "":
            self.logger.error("Parameter (-o | outscript) must be specified if parameter '-r' is not supplied")
            return -1

        # ensure the folder given as part of outscript exists
        if not self.outScript == "":
            # if current folder - then ok
            absFolder = path.dirname(self.outScript)
            if not path.isdir(absFolder):
                self.logger.error("Parameter (-o | outscript) has not supplied a valid path (" + self.outScript + ")")
                return -1

        # -i (include build security)
        if self.include == "":
            self.include = "FALSE"
        elif not (self.include.upper() == "FALSE" or self.include.upper() == "TRUE"):
            self.logger.error("Parameter (-i | include) has not supplied a valid value (false or true)")
            return -1

        return 0
