# QtCodeChallenge
Code Challenge solution.
The incoming AccountLink object was interpreted as a Portfolio Object that holds related files or branding contained on another system.

Assumptions regarding Portfolio creation logic
1. Logic is only performed when a portfolio (link) record is created
2. External Ids are unique and therefore only one portfolio can match to one account
3. Currently no logic allows for the portfolio link to be updated
4. Accounts are only matched if both the external Id and the color match


Incoming REST API
The REST API currently only contains a doPost method for values sent in the Body.
Testing was performed using workbench and therefore Named Credentials are already in Salesforce.

If required, mock Account records can be created with the MOCK_DATA.csv

--- PortfolioIntegrationRestAPI.doPost ---

Example Request:
URL: /services/apexrest/Portfolio/
Body:
{ "items":[
    {   "externalId":"cb3183c9",
        "color":"Mauv"
    },
    {   "externalId":"07124676",
        "color":"Crimson"
    },
    {   "externalId":"4b40b761",
        "color":"Red"
    }
]}

statusCode: 200
message: OK

--- Flow: Match Portfolios and Perform Callout  - V1 ---
After the Portfolio link record is created, they are updated if a matching 
Accounts has been found (based on the external Id and Color).
An asynchronous path then calls an Apex action to perform the callout to another external system

--- PortfolioHTTPCallout.getResponseFromExternalService ---
Since the URL given in the assignment did not work full E2E testing could not be complete!
However the payload is taken from the updated Portfolio objects in the format:

{"items":[
	{"accountIdLink":"a1b2c3e4","accountId":"001Qy00000Dqx1YIAR"},
	{"accountIdLink":"f6g7h8i9","accountId":"001Qy00000Dqx1YIBR"}
]}

--- Profile: Account Manager ---
Can be assigned for users who need access to Account and Portfolio tabs and layouts

--- Permission set: Account Manager ---
Can be assigned for users who need access to Account and Portfolio objects and fields

--- Error_Log__c ---
Custom object to store information on potential errors with integration calls
