import os
import os.path


class SFConnectionConfig:

    def __init__(self, sfAccount = "", sfUser = "", sfPassword = "", sfWarehouse = "",  sfRole= ""):
        self.sfAccount = sfAccount
        self.sfUser = sfUser
        self.sfPassword = sfPassword
        self.sfWarehouse = sfWarehouse
        self.sfRole = sfRole


    def readConfig(self, configFile):


        with open(configFile) as f:
            for line in f:
                line = line.strip()
                # Ignore comments
                if line.strip() == "":
                    continue

                if line[0] == "#":
                    continue


                lineItems = line.split("=")
                if len(lineItems) != 2:
                    print("Invalid Config Line: " + line)
                else:
                    if lineItems[0].upper() == "ACCOUNT":
                        self.sfAccount = lineItems[1]
                    elif lineItems[0].upper() == "USER":
                        self.sfUser = lineItems[1]
                    elif lineItems[0].upper() == "PASSWORD":
                        self.sfPassword = lineItems[1]
                    elif lineItems[0].upper() == "ROLE":
                        self.sfRole = lineItems[1]
                    elif lineItems[0].upper() == "WAREHOUSE":
                        self.sfWarehouse = lineItems[1]

    def validate(self):
        # TODO - Add validation

        return True