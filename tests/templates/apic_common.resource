*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections

*** Variables ***
${login_json}   {"aaaUser" : {"attributes" : {"name" : "%{ACI_USERNAME}", "pwd" : "%{ACI_PASSWORD}"}}}

*** Keywords ***
Get APIC Token
    Create Session   login   %{ACI_URL}
    ${log_level}=   Set Log Level   NONE
    ${response}=   Wait Until Keyword Succeeds   6x   10s   POST On Session   login   /api/aaaLogin.json   data=${login_json}
    Set Log Level   ${log_level}
    ${r_token}=   Get Value From Json   ${response.json()}   $..token
    Set Parallel Value For Key   apic_token   ${r_token[0]}

Login APIC
    Run Only Once   Get APIC Token
    ${apic_token}=   Get Parallel Value For Key   apic_token
    Create Session   apic   %{ACI_URL}   headers={"Cookie": "APIC-cookie=${apic_token}"}
