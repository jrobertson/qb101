# Introducing the qb101 gem

    require 'qb101'
    require 'chatgpt2023.rb'

    qb = Qb101.new('/tmp/your_questions.txt')
    ca = ChatAway.new qb.to_prompts, apikey: apikey, filepath: '/tmp/chatgpt'
    ca.start
    ab  = Ab101.new(qb, '/tmp/chatgpt/chatgpt.xml', debug: true)
    ab.save '/tmp/chatgpt/abook.xml'
    File.write '/tmp/chatgpt/abook.html', ab.to_html

## Questions

>> Why ask questions?

As an AI language model, I don't have desires or motivations, but I can tell you that asking questions is important for various reasons, including:

1. Gathering information - asking questions helps you obtain more information and details about a topic, person or situation.
2. Clarifying issues - asking questions helps you to clear up any confusion or misunderstandings in a conversation or discussion.
3. Encouraging reflection - asking questions prompts people to think more deeply about their thoughts, ideas and beliefs.
4. Promoting learning - asking questions is a fundamental part of the learning process, as it aids retention and understanding of new information.
5. Building relationships - asking questions can help build trust and foster good relationships, as people feel listened to and understood.

## Resources

* https://rubygems.org/gems/qb101 qb101
* <https://github.com/jrobertson/qb101/blob/main/data/qb101.txt>

qb101 chatgpt answers questions chat book
