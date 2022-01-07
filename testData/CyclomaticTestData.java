package consumer;


/*
 * 
 */
public class CyclomaticTestData {
	
	//cyclo score 3+4+6;
	public void methodOne() {
		if(1<3) {
			//dummy
		}else {
			if(true) {
				
			}
		}

		String foo = "bar";
		switch(foo) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default:
		}
		
		String foo1 = "bar";
		switch(foo1) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default: switch(foo) {
		    case "bar":
		    case "foo":
		    case "baz":
		    default:
		  };
		}
	}
	
	//cyclo score 8;
	public void methodFour() {
		if(false || true) {
			if(true) {
				if(false) {
					
				}
			}
		}		
		
		for(int i =0; i<10; i++) {
			while(i<8) {
				
			}
			do {} while(i>4);
		}
	}
	
	//cyclo score 3;
	public void methodFive() {
		try {
			
		}catch(Exception e) {
			
		}catch(Throwable t) {
			
		}
	}
	
	public void methodSix() {
		if(1<3) {
			//dummy
		}else {
			if(true) {
				
			}
		}

		String foo = "bar";
		switch(foo) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default:
		}
		
		switch(foo) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default:
		}
		switch(foo) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default:
		}
		switch(foo) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default:
		}
		String foo1 = "bar";
		switch(foo1) {
		  case "bar":
		  case "foo":
		  case "baz":
		  default: switch(foo) {
		    case "bar":
		    case "foo":
		    case "baz":
		    default:
		  };
		}
	}
	
	public void methodSeven() {
		
		String foo = "bar";
		switch(foo) {
		  case "233bar":
		  case "foo":
		  case "baz":
		  case "1bar":
		  case "2foo":
		  case "3baz":
		  case "4bar":
		  case "5foo":
		  case "6baz":
		  case "7bar":
		  case "8foo":
		  case "9baz":
		  case "0bar":
		  case "11foo":
		  case "12baz":
		  case "14bar":
		  case "13foo":
		  case "15baz":
		  case "16bar":
		  case "17foo":
		  case "18baz":
		  case "19bar":
		  case "20foo":
		  case "21baz":
		  case "22bar":
		  case "23foo":
		  case "24baz":
		  case "25bar":
		  case "26foo":
		  case "27baz":
		  case "113foo":
		  case "123baz":
		  case "143bar":
		  case "133foo":
		  case "153baz":
		  case "163bar":
		  case "173foo":
		  case "1833baz":
		  case "193bar":
		  case "203foo":
		  case "213baz":
		  case "223bar":
		  case "233foo":
		  case "243baz":
		  case "235bar":
		  case "236foo":
		  case "27b3az":
		  case "1133foo":
		  case "1233baz":
		  case "1343bar":
		  case "1333foo":
		  case "1353baz":
		  case "1363bar":
		  case "1373foo":
		  case "138baz":
		  case "139bar":
		  case "230foo":
		  case "3":
		  case "2233bar":
		  case "2333foo":
		  case "234baz":
		  case "2335bar":
		  case "2336foo":
		  case "237baz":
		  default:
		}
		
	
	}
	
	public void methodEight() {
		String i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
		i =0;
	}
}
