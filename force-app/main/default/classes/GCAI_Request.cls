/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 * 
 */
public with sharing class GCAI_Request {
    public String model {get;set;}
    public String prompt {get; set;}
    public Decimal temperature {get; set;}
    public Integer max_tokens {get; set;}
    public Decimal top_p {get; set;}
    public Decimal frequency_penalty {get; set;}
    public Decimal presence_penalty {get; set;}

    public GCAI_Request() {
        this.model = 'gpt-3.5-turbo'; //'gpt-3.5-turbo'; // DEPERCTED Model text-davinci-003
        this.temperature = 0.3;
        this.max_tokens = 150;
        this.top_p = 1.0;
        this.frequency_penalty = 0.0;
        this.presence_penalty = 0.0;
    }

    public GCAI_Request(String prompt) {
        this.model = 'text-davinci-003'; //'gpt-3.5-turbo';
        this.temperature = 0.3;
        this.max_tokens = 150;
        this.top_p = 1.0;
        this.frequency_penalty = 0.0;
        this.presence_penalty = 0.0;
        this.prompt = prompt;
    }

    public String getJSONString(){
        return JSON.serializePretty(this, true);
    }
}