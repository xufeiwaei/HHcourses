public class Choice{
    private String theChoice;
    private int one,two,three,four,five,six;
    public Choice(String s){
	theChoice = s;
	one = s.indexOf("\"");
	two = s.indexOf("\"",one+1);
	three = s.indexOf("\"",two+1);
	four = s.indexOf("\"",three+1);
	five = s.indexOf("\"",four+1);
	six = s.indexOf("\"",five+1);
	// System.out.println(one + " " + two + " " + three + " " + four + " " + five + " " + six);
    }

    public int nrOfChoices(){
	return Integer.parseInt(theChoice.substring(one+1,two).trim());
    }

    public String getQuestion(){
	return theChoice.substring(three+1,four).trim();
    }

    public String getChoice(int nr){
	int a = five;
	int b = six;
	for(int i = 1; i<nr; i++){
	    a = b;
	    a = theChoice.indexOf("\"",a+1);
	    b = theChoice.indexOf("\"",a+1);
	}
	return theChoice.substring(a+1,b).trim();
    }
}