/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */

 @IsTest
public class GCAI_ErrorTest {
    @isTest
    static void testParse() {
        String json = '{"error": {' +
        '   "message": "Test error message failed API call",' +
        '   "type": "Access",' +
        '   "param": "auth",' +
        '   "code": 404' +
        '    }}'+
        '';

        GCAI_Error err = GCAI_Error.parse(json);
        System.assert(err != null, 'Failed to parse response');
        System.assertEquals('Test error message failed API call', err.error.message,'Failed model Id');
    }
}