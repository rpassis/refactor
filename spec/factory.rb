class Factory
  def self.text
"
//FILE: ../Test123/Test.swift
extension {
    Testing 123
    Next line
    And a third line { 
        Another level {
          And one more
        }
    }
}

//FILE: AnotherTest.swift
extension AnotherTest {
  func test() {
    print(\"a\")    
  }
}
"
  end
end