# TEST AUTOMATION FRAMEWORK REPOSITORY
This repository includes libraries and modules for API testing in __python__.

## PYTEST API AUTOMATION FRAMEWORK

### Prerequisites

#### Required python version

```
>=3.6
```

#### Required modules for pytest api testing framework:
```
--------------------------------------------------
| Modules       | Version                        |
| ------------- | ------------------------------ |
| pytest        | >=6.2.5                        |
| pytest-html   | >=3.1.1                        |
| requests      | >=2.26.0                       |
| PyJWT         | >=2.3.0                        |
| jsonschema    | >=4.2.1                        |
| cryptography  | >=36.0.1                       |
| uuid          | >=1.30
--------------------------------------------------
```

### Directory & files specifications

#### Directory structure for API testing using pytest.

```
.
+--- test_tc1_configure_ams.py
+--- config
|   +--- tc1_configure_ams_apis.json
|   +--- tc1_configure_ams_variables.json
+--- lib
|   +--- ams_json_util.py
|   +--- ams_load_config_json.py
|   +--- ams_logger.py
|   +--- ams_mqtt_util.py
|   +--- ams_send_request_util.py
|   +--- ams_util.py
|   +--- __init__.py                                                 
```

>__1__. Define initial variable and API json files [<testcasename>_variables.json and <testcasename>_apis.json] in config/ directory mentioned in above directory tree.

>__2__. User has to create test_<testcasename>.py script in current working directory.

>__3__. <testcasename> should be same in main pytest python script, variable & apis json files.


#### File config/<testcasename>_variables.json format
```
{
	"protocol": "HTTPS",
	"env": "<somevalue>",
	"taf": "34.82.119.94",
	"taf_port": "3005",
    "devcount": 1
}
```
>User can define more initial variables in this file to execute API test cases based on their need.


#### File config/<testcasename>_apis.json format
```
{
	"baseheader": {
		"ampApiKey": false,
		"X-Client-Id": "cat"
	},
	"env_vars": {
		"skip": <boolean>,
		"method": "<GET|POST|PUT|DELETE|PATCH|OPTIONS>",
		"host": "<taf|host(for dphost)|host_spc|host_kc>",
		"endpoint": "<str>i.e.- /qd/env/{env}",
		"header": {
			"X-Client-Id": "<str>",
			"env_secret": "<str>",
			"Content-Type": "<str>"
		},
		"data": <boolean>,
		"validation": {
			"status_code": "<str> multiple codes can also be validated i.e. 200,201",
			"message": <boolean> or "<str>",
			"resp_data": <boolean>
		},
		"showPayload": <boolean>,
		"storedata": {
			"type": "env" for getting env variables from taf server api
            "key of value to be store from API response": "key to store in varobj dict"
		}
	}
}
```


>1. root key "baseheader" key should be exist in <testcasename>_apis.json file as common header for all API's mentioned in file.

>2. User can define N number of required API format as above with unique root key within this file to execute each test case by main test_<testcasename>.py script.

>3. Special keys & blocks information for calling API request inside each JSON block in test case API config file.

>>a) __"skip"__ : To skip test case set the value to true, default is false.

>>b) __"method"__: API http method can be set to GET,POST,PUT,DELETE,PATCH,OPTIONS.

>>c) __"host"__: Value can be set as "taf|host|host_spc|host_kc". 

>>>__taf__ for http request as variable define in variables.json file.

>>>__host__ for https request to dphost hosted  aaplication.

>>>__host_spc__ for https request to spchost hosted  aaplication.

>>>__host_kc__ for https request to keycloak hosted aaplication.

>>d) __"endpoint"__: Endpoint of defined host http[s] request.

>>e) __"header"__: Additional header for defined API that will be merged to baseheader before sending the request to host. JSON Key Value object block.

>>f) __"data"__: payload data for http[s] request. false or JSON Key Value object block.

>>g) __"validation"__: To validate response code, payload data & response message. JSON Key Value object block.
>>>g.1) __"status_code"__: To validate status code. string object i.e. "200,201".

>>>g.2) __"message"__: To validate response message. boolean false or string object i.e. "OK|Created".

>>>g.3) __"resp_data"__: To validate key, value in response payload data. boolean false or JSON Key Value object block to search given key, value in response payload data. if only key needs to check in certain condition, user can set value as boolean false for that key.
i.e.-
```
"resp_data": false
==>In this case response data would not be validated as set to false.

or

"resp_data": {
               "access_token": false,
               "token_type": "bearer"
             }
==> In this case for first element "access_token" key would be validated in response payload data.
as we have set false value for not to validate it's value.
==> for second element key "token_type" and its value "bearer" will be validated.
```
>> h) __"showPayload"__: Boolean true To print response payload data to console else set it false.

>> i) __"storedata"__: Boolean false to not store any data from response payload or define JSON key, value block.
```

"storedata": false
==>In this case response data would not be validated as set to false.

or

"storedata": {
               "parseJWT": {
				 "access_token": {
                    "sub": "acctDN"
                },
               "access_token": "azsAccessToken",
               "token_type": false
             }

==> Special key parseJWT token can be used to get values from encrypted JWT token.
Define this parseJWT key as JSON key, value object block.
In this example: as "parseJWT" key is present, "access_token" key will be fetched from response payload.
And that encrypted token will be parsed to get the value "sub" from it.
And store that value as "acctDN" key in python dictionary object for further use.

==> For second key,value: key "access_token" will be fetched from response data.
And it's value will be stored as "azsAccessToken" for further API use in python script.

==> for third key, value: value of token_type key from response data will be stored with same name.
And that key value will be used by python dictionary object for further API calling.

```

#### Modification in main pytest test_<testcasename>.py script

1. User can copy the provides script with the new same testcasename with which config files created.

2. User only needs to modify set_vars function inside this script for initializing required values before executing defined api testcase in config api json file.

#### lib/ directory files functions overview.

1. \_\_init\_\_.py: package file to import required module in test_<testcasename>.py file.
2. ams_load_config_json.py: 
>>Function get_config_variables: Return variables python dict object from <testcasename>_variables.json file.

>>Function get_config_apis: Return variables python dict object from <testcasename>_apis.json file.

>>Class Vardata: Creates class object for variables python dict.

>>Class Apidata: Creates class object for apis python dict.

>>Function makevalues: Returns random values based on uuid/integer/alphanum based on the parameters.

>>Function random_with_N_digits: Returns random nth digit integer.

>>Function generate_uuid: Returns random hex type id.

>>Function refresh_values: append random values in variables python dict object.

3. ams_json_util.py:
>>Class JsonUtil: Validate API response payload and parse jwt token methods.

4. ams_logger.py:
>>Class Logger: Logger object to enable logging.
>>Function writelog: Writes log for API responses.

5. ams_send_request_util.py:
>>Class SendApiRequest: Send API request with header and required body, response code, response message, response data validate methods.

>>Function make_api_request: Returns python tuple after fetching all API data from api python dictionary object.

>>Function set_init_vars: Returns python tuple with all required data to call api and get response for test case.

>>Function save_data_from_api_response: Returns boolean based on storedata to variables dictionary object from json object defined in API file.

6. ams_util.py:
>>Function feeddata: Append variables dictionary from API response dictionary.

>>Function encodeb64: return base64 encoded string for used in Header Authorization APIS.

>>Function merge_dict: Returns merged dictionary.



