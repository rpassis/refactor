module Factory
  class SourceCode
    def number_of_files
      2
    end
  
    def text
"
// Comment line 1
// Comment line 2
// Comment line 3

import UIKit
import FrameworkABC

class AppDelegate {
  func test() {
    print('tested')
  }
}

// FILE: ../Test123/Test.swift
extension {
    Testing 123
    Next line
    And a third line { 
        Another level {
          And one more
        }
    }
}
// END
// FILE: AnotherTest.swift

extension AnotherTest {
  func test() {
    print(\"a\")    
  }
}
// END
"
    end

    def modified_text
"
class AppDelegate {
  func test() {
    print('tested')
  }
}
"
    end
  end
end