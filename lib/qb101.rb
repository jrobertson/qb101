#!/usr/bin/env ruby

# file: qb101.tb

# Description: Makes it convenient to create a questions and anwers book. 
#              To be used in conjunction with the ChatGpt2023 gem.
# see https://github.com/jrobertson/qb101/blob/main/data/qb101.txt for 
# an example of questions used

require 'yatoc'
require 'polyrex-headings'
require 'kramdown'


# This file contains 2 classes, the question book class and 
# the answer book class.


class Qb101

  def initialize(questions_file=nil)
    
    questions_file ||= File.join(File.dirname(__FILE__), '..',
                                'data', 'qb101.txt')

    s = File.read(questions_file)
    @questions = s[/#.*/m]
    @px = PolyrexHeadings.new(s, debug: false).to_polyrex

  end
  
  def question(id)

    found = @px.find_by_id(id.to_s)
    found.x if found

  end

  alias q question
  
  def questions()
    doc = Rexle.new('<root>' + self.to_html + '</root>')
    a = doc.root.xpath('//p/text()').map(&:to_s)    
  end

  def tags()
    @px.summary.tags
  end
  
  def title()
    @px.summary.title
  end
  
  def to_md()
    @questions
  end
  
  def to_html()
    s = @questions.strip.gsub(/^([^\n#].[^\n]+)[\n]+/,'\1' + "\n\n")
    Kramdown::Document.new(s).to_html
  end
  
  def to_prompts()
    
    # generates a Dynarex file for use with ChatAway class in ChaptGpt2023
    dx = Dynarex.new('prompts/entry(prompt,type, redo)')
    
    questions().each {|x| dx.create({prompt: x, type: 'completion'}) }
    
    return dx

  end
  
  def to_toc()
    Yatoc.new(self.to_html(), min_sections: 1)    
  end
  
  def to_xml()
    @px.to_xml(pretty: true)
  end

end

class Ab101

  # note: the ab_xml file can be in CGRecorder log XML format
  
  def initialize(qb, ab_xml=nil, filepath: '.', debug: false)
    
    @debug = debug
    
    @qb = if qb.is_a?(String) and qb.lines.length < 2 then
      Qb101.new(qb)
    elsif qb.kind_of?(Qb101)
      qb
    end
    
    @dx = Dynarex.new('book[title, tags]/item(question, answer)')
    @dx.title = @qb.title
    @dx.tags = @qb.tags
    
    @qb.questions.each {|q| @dx.create({question: q}) }
    
    if ab_xml and File.exist?(ab_xml) then
      
      dx = Dynarex.new(ab_xml)
      
      # using each question, find the associated answer and 
      # add it the main record
      
      @qb.questions.each do |q|
        
        puts 'q: ' + q.inspect if @debug
  
        # note: the find_by ... method is passing in a regex because passing 
        #       in a String causes the xpath to execute which is known to have 
        #       a serious bug when the value contains *and*.
        if dx.schema =~ /question, answer/ then

          found = dx.find_by_question /#{q}/
          
          if found then
            rx = @dx.find_by_question /#{q}/
            rx.answer = found.answer 
          end
          
        else
          
          #puts 'dx: ' + dx.to_xml(pretty: true) if @debug
          found = dx.find_by_prompt /#{q}/
          puts 'found: ' + found.inspect if @debug
          
          if found then
            rx = @dx.find_by_question /#{q}/
            rx.answer = found.result 
          end
          
        end
        
      end
      
      #@dx.save ab_xml
      
    end
    
  end

  def save(filename)
    @dx.save filename
  end
  
  def to_html()

    doc = Rexle.new('<body>' + @qb.to_html.gsub(/<p>[^>]+>/,'<div>\0</div>') \
                    + '</body>')
    answers = @dx.all.map(&:answer)
    
    puts 'answers: ' + answers.inspect if @debug
    
    doc.root.xpath('//p').each.with_index do |para, i|


      s = answers[i].strip
      
      e = if s.lines.length > 1 then
      
        html = "<span>%s</span>" % Kramdown::Document.new(s).to_html      
        Rexle.new(html).root
        
      else
        
        Rexle::Element.new('p', attributes: {class: 'answer'})\
            .add_text s
        
      end
      para.insert_after e
      
    end
    
    doc.root.xml pretty: true
  end
  
  def to_xml()
    @dx.to_xml(pretty: true)
  end

end
