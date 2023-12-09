/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 * @Author: igor.androsov 
 * @Date: 2023-12-09 15:24:12 
 * @Last Modified by: igor.androsov
 * @Last Modified time: 2023-12-09 18:46:37
 */
@isTest
public class GCAI_ResponseTest {
	@isTest
	static void testParse() {
		String json = '{\"id\":\"e0b54160-1a64-4ce7-b518-5aa2ee4d4e1e\",'+
                        '\"created\":1638420208,'+
                        '\"model\":\"gpt-3.5-turbo-instruct\",'+
                        '\"choices\":[{'+
                                    '\"text\":\"A\",'+
                                    '\"index\":0,'+
                                    '\"logprobs\":0,'+
                                    '\"finish_reason\":\"stop\"'+
                                    '}],'+
                        '\"usage\":{'+
                                    '\"prompt_tokens\":1,'+
                                    '\"completion_tokens\":1,'+
                                    '\"total_tokens\":1}}';
		GCAI_Response r = GCAI_Response.parse(json);
        // Constructors defaults
        GCAI_Response.GCAI_Usage usg = new GCAI_Response.GCAI_Usage();
        usg.prompt_tokens = 1024;
        GCAI_Response.GCAI_Choice choice = new GCAI_Response.GCAI_Choice();
        choice.text = 'Test text';
        choice.index = 0;
        choice.finish_reason = 'stop';
        List<GCAI_Response.GCAI_Choice> choices = new List<GCAI_Response.GCAI_Choice >();
        choices.add(choice);

        GCAI_Response res = new GCAI_Response();
        res.choices = choices;
        res.usage = usg;

		System.assertEquals('e0b54160-1a64-4ce7-b518-5aa2ee4d4e1e', r.id, 'Invalid record id');
		System.assertEquals(1638420208, r.created, 'Invalid created date');
		System.assertEquals('gpt-3.5-turbo-instruct', r.model, 'Invalid model name');
		System.assertEquals('A', r.choices[0].text, 'Invalid choices in response');
		System.assertEquals(1, r.usage.prompt_tokens, 'Invalid usage tokens');
	}

    // sf apex run test --class-names GCAI_ResponseTest --result-format human --synchronous
}
