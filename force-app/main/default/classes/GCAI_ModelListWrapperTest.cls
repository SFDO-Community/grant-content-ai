/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
@IsTest
public class GCAI_ModelListWrapperTest {
    @isTest
    static void testParse() {
        String json = '{"data": [{'+
        '      "id": "text-davinci-001",'+
        '      "object": "model",'+
        '      "created": 1649364042,'+
        '      "owned_by": "openai",'+
        '      "permission": ['+
        '        {'+
        '          "id": "modelperm-MVM5NfoRjXkDve3uQW3YZDDt",'+
        '          "object": "model_permission",'+
        '          "created": 1669066355,'+
        '          "allow_create_engine": false,'+
        '          "allow_sampling": true,'+
        '          "allow_logprobs": true,'+
        '          "allow_search_indices": false,'+
        '          "allow_view": true,'+
        '          "allow_fine_tuning": false,'+
        '          "organization": "*",'+
        '          "group": null,'+
        '          "is_blocking": false'+
        '        }'+
        '      ],'+
        '      "root": "text-davinci-001",'+
        '      "parent": null'+
        '    }]'+
        '}';
        GCAI_ModelListWrapper wrap = GCAI_ModelListWrapper.parse(json);
        System.assert(wrap != null, 'Failed to parse response');
    }
}