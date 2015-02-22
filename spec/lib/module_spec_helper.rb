def verify_exact_contents(subject, title, expected_lines)
  get_content(subject, title).should == expected_lines
end

def get_content(subject, title)
  content = subject.resource('file', title).send(:parameters)[:content]
  content.split(/\n/).reject { |line| line =~ /(^#|^$|^\s+#)/ }
end
