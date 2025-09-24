import logging
import getpass


class SFPrompt:

    def getPassword(self):

        password = ""

        while password == "":
            password = getpass.getpass(prompt = 'Enter SF password ==> ')

        return password

