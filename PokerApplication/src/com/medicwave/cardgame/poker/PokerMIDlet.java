/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

import javax.microedition.midlet.*;
import javax.microedition.lcdui.*;
import com.medicwave.cardgame.*;
import ca.ualberta.cs.poker.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Hashtable;
import javax.microedition.media.Manager;
import javax.microedition.media.MediaException;
import javax.microedition.media.Player;
import se.lypson.common.collections.IForwardIterator;
import se.lypson.common.thread.IThreadObserver;
import se.lypson.common.thread.Thread;

/**
 * @author Tobias Persson
 */
public class PokerMIDlet extends MIDlet implements CommandListener, IThreadObserver, ITextReceiver {

    private boolean midletPaused = false;
    
    private PokerServer pokerServer;
    private PokerClientBase pokerClient;

    private PokerGamePlayCanvas canvasPokerGamePlay;
    private Command cmdPokerStandingsMessages;
    
    private final int numberOfTextMessagesToDisplay = 8;
    
    private static final String BACKGROUNDMUSIC_FILENAME = "/casino.mid";
    private Player backgroundMusicPlayer = null;

//<editor-fold defaultstate="collapsed" desc=" Generated Fields ">//GEN-BEGIN:|fields|0|
private Command cmdIntroOk;
private Command cmdIntroExit;
private Command cmdServerClientOk;
private Command cmdServerClientExit;
private Command cmdServerSetupExit;
private Command cmdServerSeupOk;
private Command cmdClientSetupExit;
private Command cmdClientSetupOk;
private Command cmdServerMessagesExit;
private Command cmdFinalResultExit;
private Command cmdClientMessagesExit;
private Command cmdServerMessagesStandings;
private Command cmdServerStandingsMessages;
private Command cmdServerStandingsExit;
private TextBox tbIntro;
private List lstServerClient;
private Form frmServerSetup;
private TextField txtServerSetupPort;
private ChoiceGroup grpServerSetupNumberOfClients;
private TextField txtServerSetupRaiseAnteRoundCount;
private TextField txtServerSetupResponseTime;
private TextField txtServerSetupAnteValue;
private TextField txtServerSetupPlayersInitialChips;
private ChoiceGroup cgServerSetupPlayBackgroundMusic;
private Form frmClientSetup;
private TextField txtClientSetupServerAddress;
private TextField txtClientSetupServerPort;
private List lstFinalResult;
private Form frmServerMessages;
private Form frmClientMessages;
//</editor-fold>//GEN-END:|fields|0|

    /**
     * The PokerMIDlet constructor.
     */
    public PokerMIDlet() {
        Deck deck = new Deck();
        System.out.println("Displaying deck...");
        for( int i = 0; deck.cardsLeft() > 0; ++i)
        {
            Card currentCard = deck.deal();
            System.out.println("Card #"+i+": "+currentCard);
        }
        System.out.println("...done.");
        deck.shuffle();
        System.out.println("Displaying shuffled deck...");
        for( int i = 0; deck.cardsLeft() > 0; ++i)
        {
            Card currentCard = deck.deal();
            System.out.println("Card #"+i+": "+currentCard);
        }
        System.out.println("...done.");
        System.out.println("Creating Royal Straight Flash hand...");
        Hand straightFlushHand = new Hand();
        straightFlushHand.addCard( new Card(Card.TEN, Card.SPADES) );
        straightFlushHand.addCard( new Card(Card.JACK, Card.SPADES) );
        straightFlushHand.addCard( new Card(Card.QUEEN, Card.SPADES) );
        straightFlushHand.addCard( new Card(Card.KING, Card.SPADES) );
        straightFlushHand.addCard( new Card(Card.ACE, Card.SPADES) );
        System.out.println("...done.");
        System.out.println( "Hand is '"+straightFlushHand+"', rank is "+HandEvaluator.rankHand(straightFlushHand)+
                            ", name is '"+HandEvaluator.nameHand(straightFlushHand)+"'.");
        System.out.println("Cards remaining in deck: "+deck.cardsLeft());
        System.out.println("Resetting deck.");
        deck.reset();
        System.out.println("Cards remaining in deck: "+deck.cardsLeft());
        Hand randomHand = new Hand();
        for( int i = 0; i < 5; ++i )
            randomHand.addCard(deck.deal());
        System.out.println("Gave a random hand "+randomHand.size()+" cards from the deck.");
        System.out.println("Cards remaining in deck: "+deck.cardsLeft());
        System.out.println( "Random hand is '"+randomHand+"', rank is "+HandEvaluator.rankHand(randomHand)+
                            ", name is '"+HandEvaluator.nameHand(randomHand)+"'.");
        Hand worstHand = new Hand(" 7d 5d 4d 3d 2c");
        System.out.println( "Worst hand is '"+worstHand+"', rank is "+HandEvaluator.rankHand(worstHand)+
                            ", name is '"+HandEvaluator.nameHand(worstHand)+"'.");

        String[] handStrings = {
            "7d 5d 4d 3d 2c", "7d 5d 4d 3d Ac", // High card
            "As Ah 4d 3d 2c", "Ac Ad 9d 7d 5c", // Pair
            "Ac Ad 9d 7d 9c", "Kc Kd 9d 7d 9c", // Two pair.
            "4s 4h 4d 3d 2c", "Ac Ad 9d Ad 5c", // Three of a Kind
            "Ad 2d 3d 4d 5c", "2d 3d 4d 5d 6c", // Straight
            "Ad 2d 3d 4d 6d", "2d 3d 4d 5d 7d", // Flush
            "4s 4h 3h 3d 3c", "4s 4h 4c 3d 3c", // Full House
            "4s 4h 4d 3d 4c", "Ac Ad 9d Ad Ac", // Four of a Kind
            "Ad 2d 3d 4d 5d", "2d 3d 4d 5d 6d", // Straight Flush
            "Ad Kd Qd Jd Td", "Ah Kh Qh Jh Th", // Royal Straight Flush
        };
        for( int i = 0; i < handStrings.length; ++i )
        {
            Hand currentHand = new Hand( handStrings[i] );
            System.out.println( "Rank of hand "+currentHand+" is "+HandEvaluator.rankHand(currentHand)+
                                ", comparation rank is "+PokerEvaluatorExtensions.getHandComparationRank(currentHand)+
                                ", name is "+HandEvaluator.nameHand(currentHand)+".");
        }
    }

//<editor-fold defaultstate="collapsed" desc=" Generated Methods ">//GEN-BEGIN:|methods|0|
//</editor-fold>//GEN-END:|methods|0|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: initialize ">//GEN-BEGIN:|0-initialize|0|0-preInitialize
/**
 * Initilizes the application.
 * It is called only once when the MIDlet is started. The method is called before the <code>startMIDlet</code> method.
 */
private void initialize () {//GEN-END:|0-initialize|0|0-preInitialize
        // write pre-initialize user code here
//GEN-LINE:|0-initialize|1|0-postInitialize
        // write post-initialize user code here
}//GEN-BEGIN:|0-initialize|2|
//</editor-fold>//GEN-END:|0-initialize|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: startMIDlet ">//GEN-BEGIN:|3-startMIDlet|0|3-preAction
/**
 * Performs an action assigned to the Mobile Device - MIDlet Started point.
 */
public void startMIDlet () {//GEN-END:|3-startMIDlet|0|3-preAction
        // write pre-action user code here
switchDisplayable (null, getTbIntro ());//GEN-LINE:|3-startMIDlet|1|3-postAction
        // write post-action user code here
}//GEN-BEGIN:|3-startMIDlet|2|
//</editor-fold>//GEN-END:|3-startMIDlet|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: resumeMIDlet ">//GEN-BEGIN:|4-resumeMIDlet|0|4-preAction
/**
 * Performs an action assigned to the Mobile Device - MIDlet Resumed point.
 */
public void resumeMIDlet () {//GEN-END:|4-resumeMIDlet|0|4-preAction
        // write pre-action user code here
    startBackgroundMusic();
//GEN-LINE:|4-resumeMIDlet|1|4-postAction
        // write post-action user code here
}//GEN-BEGIN:|4-resumeMIDlet|2|
//</editor-fold>//GEN-END:|4-resumeMIDlet|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: switchDisplayable ">//GEN-BEGIN:|5-switchDisplayable|0|5-preSwitch
/**
 * Switches a current displayable in a display. The <code>display</code> instance is taken from <code>getDisplay</code> method. This method is used by all actions in the design for switching displayable.
 * @param alert the Alert which is temporarily set to the display; if <code>null</code>, then <code>nextDisplayable</code> is set immediately
 * @param nextDisplayable the Displayable to be set
 */
public void switchDisplayable (Alert alert, Displayable nextDisplayable) {//GEN-END:|5-switchDisplayable|0|5-preSwitch
        // write pre-switch user code here
Display display = getDisplay ();//GEN-BEGIN:|5-switchDisplayable|1|5-postSwitch
if (alert == null) {
display.setCurrent (nextDisplayable);
} else {
display.setCurrent (alert, nextDisplayable);
}//GEN-END:|5-switchDisplayable|1|5-postSwitch
        // write post-switch user code here
}//GEN-BEGIN:|5-switchDisplayable|2|
//</editor-fold>//GEN-END:|5-switchDisplayable|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: commandAction for Displayables ">//GEN-BEGIN:|7-commandAction|0|7-preCommandAction
/**
 * Called by a system to indicated that a command has been invoked on a particular displayable.
 * @param command the Command that was invoked
 * @param displayable the Displayable where the command was invoked
 */
public void commandAction (Command command, Displayable displayable) {//GEN-END:|7-commandAction|0|7-preCommandAction
        // write pre-action user code here
if (displayable == frmClientMessages) {//GEN-BEGIN:|7-commandAction|1|100-preAction
if (command == cmdClientMessagesExit) {//GEN-END:|7-commandAction|1|100-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|2|100-postAction
 // write post-action user code here
}//GEN-BEGIN:|7-commandAction|3|60-preAction
} else if (displayable == frmClientSetup) {
if (command == cmdClientSetupExit) {//GEN-END:|7-commandAction|3|60-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|4|60-postAction
 // write post-action user code here
} else if (command == cmdClientSetupOk) {//GEN-LINE:|7-commandAction|5|62-preAction
 // write pre-action user code here
switchDisplayable (null, getFrmClientMessages ());//GEN-LINE:|7-commandAction|6|62-postAction
 // write post-action user code here
    String server   = txtClientSetupServerAddress.getString();
    int port        = Integer.parseInt(txtClientSetupServerPort.getString());
    pokerClient     = new PokerClient(server, port);
    pokerClient.addTextReceiver(this);
    pokerClient.addTextReceiver(new TextReceivedPrinter());
    pokerClient.start();
    pokerClient.addThreadObserver(this);
}//GEN-BEGIN:|7-commandAction|7|95-preAction
} else if (displayable == frmServerMessages) {
if (command == cmdServerMessagesExit) {//GEN-END:|7-commandAction|7|95-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|8|95-postAction
 // write post-action user code here
} else if (command == cmdServerMessagesStandings) {//GEN-LINE:|7-commandAction|9|111-preAction
 // write pre-action user code here
//GEN-LINE:|7-commandAction|10|111-postAction
 // write post-action user code here
    switchDisplayable(null, getCanvasPokerGamePlay() );
}//GEN-BEGIN:|7-commandAction|11|52-preAction
} else if (displayable == frmServerSetup) {
if (command == cmdServerSetupExit) {//GEN-END:|7-commandAction|11|52-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|12|52-postAction
 // write post-action user code here
} else if (command == cmdServerSeupOk) {//GEN-LINE:|7-commandAction|13|54-preAction
 // write pre-action user code here
switchDisplayable (null, getFrmServerMessages ());//GEN-LINE:|7-commandAction|14|54-postAction
 // write post-action user code here
    if( getCgServerSetupPlayBackgroundMusic().isSelected(0) )
    {
        loadBackgroundMusic();
        startBackgroundMusic();
    }

    int port                        = Integer.parseInt(txtServerSetupPort.getString());
    int numberOfClients             = Integer.parseInt(grpServerSetupNumberOfClients.getString(
                                                        grpServerSetupNumberOfClients.getSelectedIndex()));
    int playersStartChips           = Integer.parseInt(txtServerSetupPlayersInitialChips.getString());
    int ante                        = Integer.parseInt(txtServerSetupAnteValue.getString());
    int raiseAnteAfterRoundsCount   = Integer.parseInt(txtServerSetupRaiseAnteRoundCount.getString());
    int responseTime                = Integer.parseInt(txtServerSetupResponseTime.getString());
    this.pokerServer = new PokerServer(port, numberOfClients, playersStartChips, ante, raiseAnteAfterRoundsCount, responseTime);
    pokerServer.addTextReceiver(this);
    pokerServer.addTextReceiver(new TextReceivedPrinter());
    pokerServer.start();
    pokerServer.addThreadObserver(this);
    pokerServer.addGameObserver(getCanvasServerGamePlayObserver());
}//GEN-BEGIN:|7-commandAction|15|88-preAction
} else if (displayable == lstFinalResult) {
if (command == List.SELECT_COMMAND) {//GEN-END:|7-commandAction|15|88-preAction
 // write pre-action user code here
lstFinalResultAction ();//GEN-LINE:|7-commandAction|16|88-postAction
 // write post-action user code here
} else if (command == cmdFinalResultExit) {//GEN-LINE:|7-commandAction|17|91-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|18|91-postAction
 // write post-action user code here
}//GEN-BEGIN:|7-commandAction|19|35-preAction
} else if (displayable == lstServerClient) {
if (command == List.SELECT_COMMAND) {//GEN-END:|7-commandAction|19|35-preAction
 // write pre-action user code here
lstServerClientAction ();//GEN-LINE:|7-commandAction|20|35-postAction
 // write post-action user code here
} else if (command == cmdServerClientExit) {//GEN-LINE:|7-commandAction|21|41-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|22|41-postAction
 // write post-action user code here
} else if (command == cmdServerClientOk) {//GEN-LINE:|7-commandAction|23|44-preAction
 // write pre-action user code here
lstServerClientAction ();//GEN-LINE:|7-commandAction|24|44-postAction
 // write post-action user code here
}//GEN-BEGIN:|7-commandAction|25|31-preAction
} else if (displayable == tbIntro) {
if (command == cmdIntroExit) {//GEN-END:|7-commandAction|25|31-preAction
 // write pre-action user code here
exitMIDlet ();//GEN-LINE:|7-commandAction|26|31-postAction
 // write post-action user code here
} else if (command == cmdIntroOk) {//GEN-LINE:|7-commandAction|27|29-preAction
 // write pre-action user code here
switchDisplayable (null, getLstServerClient ());//GEN-LINE:|7-commandAction|28|29-postAction
 // write post-action user code here
}//GEN-BEGIN:|7-commandAction|29|7-postCommandAction
}//GEN-END:|7-commandAction|29|7-postCommandAction
        // write post-action user code here
    else if( displayable == canvasPokerGamePlay )
    {
        if( command == cmdPokerStandingsMessages )
        {
            switchDisplayable(null, getFrmServerMessages() );
        }
    }

}//GEN-BEGIN:|7-commandAction|30|
//</editor-fold>//GEN-END:|7-commandAction|30|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdIntroOk ">//GEN-BEGIN:|28-getter|0|28-preInit
/**
 * Returns an initiliazed instance of cmdIntroOk component.
 * @return the initialized component instance
 */
public Command getCmdIntroOk () {
if (cmdIntroOk == null) {//GEN-END:|28-getter|0|28-preInit
 // write pre-init user code here
cmdIntroOk = new Command ("Ok", Command.OK, 0);//GEN-LINE:|28-getter|1|28-postInit
 // write post-init user code here
}//GEN-BEGIN:|28-getter|2|
return cmdIntroOk;
}
//</editor-fold>//GEN-END:|28-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdIntroExit ">//GEN-BEGIN:|30-getter|0|30-preInit
/**
 * Returns an initiliazed instance of cmdIntroExit component.
 * @return the initialized component instance
 */
public Command getCmdIntroExit () {
if (cmdIntroExit == null) {//GEN-END:|30-getter|0|30-preInit
 // write pre-init user code here
cmdIntroExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|30-getter|1|30-postInit
 // write post-init user code here
}//GEN-BEGIN:|30-getter|2|
return cmdIntroExit;
}
//</editor-fold>//GEN-END:|30-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerClientExit ">//GEN-BEGIN:|40-getter|0|40-preInit
/**
 * Returns an initiliazed instance of cmdServerClientExit component.
 * @return the initialized component instance
 */
public Command getCmdServerClientExit () {
if (cmdServerClientExit == null) {//GEN-END:|40-getter|0|40-preInit
 // write pre-init user code here
cmdServerClientExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|40-getter|1|40-postInit
 // write post-init user code here
}//GEN-BEGIN:|40-getter|2|
return cmdServerClientExit;
}
//</editor-fold>//GEN-END:|40-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerClientOk ">//GEN-BEGIN:|43-getter|0|43-preInit
/**
 * Returns an initiliazed instance of cmdServerClientOk component.
 * @return the initialized component instance
 */
public Command getCmdServerClientOk () {
if (cmdServerClientOk == null) {//GEN-END:|43-getter|0|43-preInit
 // write pre-init user code here
cmdServerClientOk = new Command ("Ok", Command.OK, 0);//GEN-LINE:|43-getter|1|43-postInit
 // write post-init user code here
}//GEN-BEGIN:|43-getter|2|
return cmdServerClientOk;
}
//</editor-fold>//GEN-END:|43-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: tbIntro ">//GEN-BEGIN:|23-getter|0|23-preInit
/**
 * Returns an initiliazed instance of tbIntro component.
 * @return the initialized component instance
 */
public TextBox getTbIntro () {
if (tbIntro == null) {//GEN-END:|23-getter|0|23-preInit
 // write pre-init user code here
tbIntro = new TextBox ("Poker server/client", "Developed for Intelligent Systems Lab, IDE-school, University of Halmstad, september 2008.", 100, TextField.ANY | TextField.UNEDITABLE);//GEN-BEGIN:|23-getter|1|23-postInit
tbIntro.addCommand (getCmdIntroOk ());
tbIntro.addCommand (getCmdIntroExit ());
tbIntro.setCommandListener (this);//GEN-END:|23-getter|1|23-postInit
 // write post-init user code here
}//GEN-BEGIN:|23-getter|2|
return tbIntro;
}
//</editor-fold>//GEN-END:|23-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: lstServerClient ">//GEN-BEGIN:|33-getter|0|33-preInit
/**
 * Returns an initiliazed instance of lstServerClient component.
 * @return the initialized component instance
 */
public List getLstServerClient () {
if (lstServerClient == null) {//GEN-END:|33-getter|0|33-preInit
 // write pre-init user code here
lstServerClient = new List ("Select server or client", Choice.EXCLUSIVE);//GEN-BEGIN:|33-getter|1|33-postInit
lstServerClient.append ("Server", null);
lstServerClient.append ("Client", null);
lstServerClient.addCommand (getCmdServerClientExit ());
lstServerClient.addCommand (getCmdServerClientOk ());
lstServerClient.setCommandListener (this);
lstServerClient.setSelectedFlags (new boolean[] { false, false });//GEN-END:|33-getter|1|33-postInit
 // write post-init user code here
}//GEN-BEGIN:|33-getter|2|
return lstServerClient;
}
//</editor-fold>//GEN-END:|33-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: lstServerClientAction ">//GEN-BEGIN:|33-action|0|33-preAction
/**
 * Performs an action assigned to the selected list element in the lstServerClient component.
 */
public void lstServerClientAction () {//GEN-END:|33-action|0|33-preAction
 // enter pre-action user code here
String __selectedString = getLstServerClient ().getString (getLstServerClient ().getSelectedIndex ());//GEN-BEGIN:|33-action|1|37-preAction
if (__selectedString != null) {
if (__selectedString.equals ("Server")) {//GEN-END:|33-action|1|37-preAction
 // write pre-action user code here
switchDisplayable (null, getFrmServerSetup ());//GEN-LINE:|33-action|2|37-postAction
 // write post-action user code here
} else if (__selectedString.equals ("Client")) {//GEN-LINE:|33-action|3|38-preAction
 // write pre-action user code here
switchDisplayable (null, getFrmClientSetup ());//GEN-LINE:|33-action|4|38-postAction
 // write post-action user code here
}//GEN-BEGIN:|33-action|5|33-postAction
}//GEN-END:|33-action|5|33-postAction
 // enter post-action user code here
}//GEN-BEGIN:|33-action|6|
//</editor-fold>//GEN-END:|33-action|6|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: frmServerSetup ">//GEN-BEGIN:|45-getter|0|45-preInit
/**
 * Returns an initiliazed instance of frmServerSetup component.
 * @return the initialized component instance
 */
public Form getFrmServerSetup () {
if (frmServerSetup == null) {//GEN-END:|45-getter|0|45-preInit
 // write pre-init user code here
frmServerSetup = new Form ("Server Setup", new Item[] { getTxtServerSetupPort (), getGrpServerSetupNumberOfClients (), getTxtServerSetupPlayersInitialChips (), getTxtServerSetupAnteValue (), getTxtServerSetupRaiseAnteRoundCount (), getTxtServerSetupResponseTime (), getCgServerSetupPlayBackgroundMusic () });//GEN-BEGIN:|45-getter|1|45-postInit
frmServerSetup.addCommand (getCmdServerSetupExit ());
frmServerSetup.addCommand (getCmdServerSeupOk ());
frmServerSetup.setCommandListener (this);//GEN-END:|45-getter|1|45-postInit
 // write post-init user code here
}//GEN-BEGIN:|45-getter|2|
return frmServerSetup;
}
//</editor-fold>//GEN-END:|45-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerSetupExit ">//GEN-BEGIN:|51-getter|0|51-preInit
/**
 * Returns an initiliazed instance of cmdServerSetupExit component.
 * @return the initialized component instance
 */
public Command getCmdServerSetupExit () {
if (cmdServerSetupExit == null) {//GEN-END:|51-getter|0|51-preInit
 // write pre-init user code here
cmdServerSetupExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|51-getter|1|51-postInit
 // write post-init user code here
}//GEN-BEGIN:|51-getter|2|
return cmdServerSetupExit;
}
//</editor-fold>//GEN-END:|51-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerSeupOk ">//GEN-BEGIN:|53-getter|0|53-preInit
/**
 * Returns an initiliazed instance of cmdServerSeupOk component.
 * @return the initialized component instance
 */
public Command getCmdServerSeupOk () {
if (cmdServerSeupOk == null) {//GEN-END:|53-getter|0|53-preInit
 // write pre-init user code here
cmdServerSeupOk = new Command ("Ok", Command.OK, 0);//GEN-LINE:|53-getter|1|53-postInit
 // write post-init user code here
}//GEN-BEGIN:|53-getter|2|
return cmdServerSeupOk;
}
//</editor-fold>//GEN-END:|53-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdClientSetupExit ">//GEN-BEGIN:|59-getter|0|59-preInit
/**
 * Returns an initiliazed instance of cmdClientSetupExit component.
 * @return the initialized component instance
 */
public Command getCmdClientSetupExit () {
if (cmdClientSetupExit == null) {//GEN-END:|59-getter|0|59-preInit
 // write pre-init user code here
cmdClientSetupExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|59-getter|1|59-postInit
 // write post-init user code here
}//GEN-BEGIN:|59-getter|2|
return cmdClientSetupExit;
}
//</editor-fold>//GEN-END:|59-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdClientSetupOk ">//GEN-BEGIN:|61-getter|0|61-preInit
/**
 * Returns an initiliazed instance of cmdClientSetupOk component.
 * @return the initialized component instance
 */
public Command getCmdClientSetupOk () {
if (cmdClientSetupOk == null) {//GEN-END:|61-getter|0|61-preInit
 // write pre-init user code here
cmdClientSetupOk = new Command ("Ok", Command.OK, 0);//GEN-LINE:|61-getter|1|61-postInit
 // write post-init user code here
}//GEN-BEGIN:|61-getter|2|
return cmdClientSetupOk;
}
//</editor-fold>//GEN-END:|61-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtServerSetupPort ">//GEN-BEGIN:|73-getter|0|73-preInit
/**
 * Returns an initiliazed instance of txtServerSetupPort component.
 * @return the initialized component instance
 */
public TextField getTxtServerSetupPort () {
if (txtServerSetupPort == null) {//GEN-END:|73-getter|0|73-preInit
 // write pre-init user code here
txtServerSetupPort = new TextField ("Server port:", "5000", 5, TextField.NUMERIC);//GEN-LINE:|73-getter|1|73-postInit
 // write post-init user code here
}//GEN-BEGIN:|73-getter|2|
return txtServerSetupPort;
}
//</editor-fold>//GEN-END:|73-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: grpServerSetupNumberOfClients ">//GEN-BEGIN:|74-getter|0|74-preInit
/**
 * Returns an initiliazed instance of grpServerSetupNumberOfClients component.
 * @return the initialized component instance
 */
public ChoiceGroup getGrpServerSetupNumberOfClients () {
if (grpServerSetupNumberOfClients == null) {//GEN-END:|74-getter|0|74-preInit
 // write pre-init user code here
grpServerSetupNumberOfClients = new ChoiceGroup ("Number of clients:", Choice.POPUP);//GEN-BEGIN:|74-getter|1|74-postInit
grpServerSetupNumberOfClients.append ("2", null);
grpServerSetupNumberOfClients.append ("3", null);
grpServerSetupNumberOfClients.append ("4", null);
grpServerSetupNumberOfClients.append ("5", null);
grpServerSetupNumberOfClients.setSelectedFlags (new boolean[] { false, false, false, false });
grpServerSetupNumberOfClients.setFont (0, null);
grpServerSetupNumberOfClients.setFont (1, null);
grpServerSetupNumberOfClients.setFont (2, null);
grpServerSetupNumberOfClients.setFont (3, null);//GEN-END:|74-getter|1|74-postInit
 // write post-init user code here
}//GEN-BEGIN:|74-getter|2|
return grpServerSetupNumberOfClients;
}
//</editor-fold>//GEN-END:|74-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtServerSetupPlayersInitialChips ">//GEN-BEGIN:|80-getter|0|80-preInit
/**
 * Returns an initiliazed instance of txtServerSetupPlayersInitialChips component.
 * @return the initialized component instance
 */
public TextField getTxtServerSetupPlayersInitialChips () {
if (txtServerSetupPlayersInitialChips == null) {//GEN-END:|80-getter|0|80-preInit
 // write pre-init user code here
txtServerSetupPlayersInitialChips = new TextField ("Players initital amount of chips:", "200", 8, TextField.NUMERIC);//GEN-LINE:|80-getter|1|80-postInit
 // write post-init user code here
}//GEN-BEGIN:|80-getter|2|
return txtServerSetupPlayersInitialChips;
}
//</editor-fold>//GEN-END:|80-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtServerSetupAnteValue ">//GEN-BEGIN:|81-getter|0|81-preInit
/**
 * Returns an initiliazed instance of txtServerSetupAnteValue component.
 * @return the initialized component instance
 */
public TextField getTxtServerSetupAnteValue () {
if (txtServerSetupAnteValue == null) {//GEN-END:|81-getter|0|81-preInit
 // write pre-init user code here
txtServerSetupAnteValue = new TextField ("Initial ante:", "10", 8, TextField.NUMERIC);//GEN-LINE:|81-getter|1|81-postInit
 // write post-init user code here
}//GEN-BEGIN:|81-getter|2|
return txtServerSetupAnteValue;
}
//</editor-fold>//GEN-END:|81-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: frmClientSetup ">//GEN-BEGIN:|49-getter|0|49-preInit
/**
 * Returns an initiliazed instance of frmClientSetup component.
 * @return the initialized component instance
 */
public Form getFrmClientSetup () {
if (frmClientSetup == null) {//GEN-END:|49-getter|0|49-preInit
 // write pre-init user code here
frmClientSetup = new Form ("Client Setup", new Item[] { getTxtClientSetupServerAddress (), getTxtClientSetupServerPort () });//GEN-BEGIN:|49-getter|1|49-postInit
frmClientSetup.addCommand (getCmdClientSetupExit ());
frmClientSetup.addCommand (getCmdClientSetupOk ());
frmClientSetup.setCommandListener (this);//GEN-END:|49-getter|1|49-postInit
 // write post-init user code here
}//GEN-BEGIN:|49-getter|2|
return frmClientSetup;
}
//</editor-fold>//GEN-END:|49-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtClientSetupServerAddress ">//GEN-BEGIN:|71-getter|0|71-preInit
/**
 * Returns an initiliazed instance of txtClientSetupServerAddress component.
 * @return the initialized component instance
 */
public TextField getTxtClientSetupServerAddress () {
if (txtClientSetupServerAddress == null) {//GEN-END:|71-getter|0|71-preInit
 // write pre-init user code here
txtClientSetupServerAddress = new TextField ("Server address:", "localhost", 32, TextField.ANY);//GEN-LINE:|71-getter|1|71-postInit
 // write post-init user code here
}//GEN-BEGIN:|71-getter|2|
return txtClientSetupServerAddress;
}
//</editor-fold>//GEN-END:|71-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtClientSetupServerPort ">//GEN-BEGIN:|72-getter|0|72-preInit
/**
 * Returns an initiliazed instance of txtClientSetupServerPort component.
 * @return the initialized component instance
 */
public TextField getTxtClientSetupServerPort () {
if (txtClientSetupServerPort == null) {//GEN-END:|72-getter|0|72-preInit
 // write pre-init user code here
txtClientSetupServerPort = new TextField ("Server port:", "5000", 5, TextField.NUMERIC);//GEN-LINE:|72-getter|1|72-postInit
 // write post-init user code here
}//GEN-BEGIN:|72-getter|2|
return txtClientSetupServerPort;
}
//</editor-fold>//GEN-END:|72-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtServerSetupRaiseAnteRoundCount ">//GEN-BEGIN:|85-getter|0|85-preInit
/**
 * Returns an initiliazed instance of txtServerSetupRaiseAnteRoundCount component.
 * @return the initialized component instance
 */
public TextField getTxtServerSetupRaiseAnteRoundCount () {
if (txtServerSetupRaiseAnteRoundCount == null) {//GEN-END:|85-getter|0|85-preInit
 // write pre-init user code here
txtServerSetupRaiseAnteRoundCount = new TextField ("Raise ante every # rounds (0 disable):", "10", 8, TextField.NUMERIC);//GEN-LINE:|85-getter|1|85-postInit
 // write post-init user code here
}//GEN-BEGIN:|85-getter|2|
return txtServerSetupRaiseAnteRoundCount;
}
//</editor-fold>//GEN-END:|85-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: txtServerSetupResponseTime ">//GEN-BEGIN:|86-getter|0|86-preInit
/**
 * Returns an initiliazed instance of txtServerSetupResponseTime component.
 * @return the initialized component instance
 */
public TextField getTxtServerSetupResponseTime () {
if (txtServerSetupResponseTime == null) {//GEN-END:|86-getter|0|86-preInit
 // write pre-init user code here
txtServerSetupResponseTime = new TextField ("Client response time (ms)", "10000", 32, TextField.NUMERIC);//GEN-LINE:|86-getter|1|86-postInit
 // write post-init user code here
}//GEN-BEGIN:|86-getter|2|
return txtServerSetupResponseTime;
}
//</editor-fold>//GEN-END:|86-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdFinalResultExit ">//GEN-BEGIN:|90-getter|0|90-preInit
/**
 * Returns an initiliazed instance of cmdFinalResultExit component.
 * @return the initialized component instance
 */
public Command getCmdFinalResultExit () {
if (cmdFinalResultExit == null) {//GEN-END:|90-getter|0|90-preInit
 // write pre-init user code here
cmdFinalResultExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|90-getter|1|90-postInit
 // write post-init user code here
}//GEN-BEGIN:|90-getter|2|
return cmdFinalResultExit;
}
//</editor-fold>//GEN-END:|90-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: lstFinalResult ">//GEN-BEGIN:|87-getter|0|87-preInit
/**
 * Returns an initiliazed instance of lstFinalResult component.
 * @return the initialized component instance
 */
public List getLstFinalResult () {
if (lstFinalResult == null) {//GEN-END:|87-getter|0|87-preInit
 // write pre-init user code here
lstFinalResult = new List ("Final Result", Choice.IMPLICIT);//GEN-BEGIN:|87-getter|1|87-postInit
lstFinalResult.addCommand (getCmdFinalResultExit ());
lstFinalResult.setCommandListener (this);//GEN-END:|87-getter|1|87-postInit
 // write post-init user code here
}//GEN-BEGIN:|87-getter|2|
return lstFinalResult;
}
//</editor-fold>//GEN-END:|87-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Method: lstFinalResultAction ">//GEN-BEGIN:|87-action|0|87-preAction
/**
 * Performs an action assigned to the selected list element in the lstFinalResult component.
 */
public void lstFinalResultAction () {//GEN-END:|87-action|0|87-preAction
 // enter pre-action user code here
String __selectedString = getLstFinalResult ().getString (getLstFinalResult ().getSelectedIndex ());//GEN-LINE:|87-action|1|87-postAction
 // enter post-action user code here
}//GEN-BEGIN:|87-action|2|
//</editor-fold>//GEN-END:|87-action|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerMessagesExit ">//GEN-BEGIN:|94-getter|0|94-preInit
/**
 * Returns an initiliazed instance of cmdServerMessagesExit component.
 * @return the initialized component instance
 */
public Command getCmdServerMessagesExit () {
if (cmdServerMessagesExit == null) {//GEN-END:|94-getter|0|94-preInit
 // write pre-init user code here
cmdServerMessagesExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|94-getter|1|94-postInit
 // write post-init user code here
}//GEN-BEGIN:|94-getter|2|
return cmdServerMessagesExit;
}
//</editor-fold>//GEN-END:|94-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: frmServerMessages ">//GEN-BEGIN:|93-getter|0|93-preInit
/**
 * Returns an initiliazed instance of frmServerMessages component.
 * @return the initialized component instance
 */
public Form getFrmServerMessages () {
if (frmServerMessages == null) {//GEN-END:|93-getter|0|93-preInit
 // write pre-init user code here
frmServerMessages = new Form ("Server Messages");//GEN-BEGIN:|93-getter|1|93-postInit
frmServerMessages.addCommand (getCmdServerMessagesExit ());
frmServerMessages.addCommand (getCmdServerMessagesStandings ());
frmServerMessages.setCommandListener (this);//GEN-END:|93-getter|1|93-postInit
 // write post-init user code here
}//GEN-BEGIN:|93-getter|2|
return frmServerMessages;
}
//</editor-fold>//GEN-END:|93-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdClientMessagesExit ">//GEN-BEGIN:|99-getter|0|99-preInit
/**
 * Returns an initiliazed instance of cmdClientMessagesExit component.
 * @return the initialized component instance
 */
public Command getCmdClientMessagesExit () {
if (cmdClientMessagesExit == null) {//GEN-END:|99-getter|0|99-preInit
 // write pre-init user code here
cmdClientMessagesExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|99-getter|1|99-postInit
 // write post-init user code here
}//GEN-BEGIN:|99-getter|2|
return cmdClientMessagesExit;
}
//</editor-fold>//GEN-END:|99-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: frmClientMessages ">//GEN-BEGIN:|98-getter|0|98-preInit
/**
 * Returns an initiliazed instance of frmClientMessages component.
 * @return the initialized component instance
 */
public Form getFrmClientMessages () {
if (frmClientMessages == null) {//GEN-END:|98-getter|0|98-preInit
 // write pre-init user code here
frmClientMessages = new Form ("Client Messages");//GEN-BEGIN:|98-getter|1|98-postInit
frmClientMessages.addCommand (getCmdClientMessagesExit ());
frmClientMessages.setCommandListener (this);//GEN-END:|98-getter|1|98-postInit
 // write post-init user code here
}//GEN-BEGIN:|98-getter|2|
return frmClientMessages;
}
//</editor-fold>//GEN-END:|98-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerStandingsExit ">//GEN-BEGIN:|104-getter|0|104-preInit
/**
 * Returns an initiliazed instance of cmdServerStandingsExit component.
 * @return the initialized component instance
 */
public Command getCmdServerStandingsExit () {
if (cmdServerStandingsExit == null) {//GEN-END:|104-getter|0|104-preInit
 // write pre-init user code here
cmdServerStandingsExit = new Command ("Exit", Command.EXIT, 0);//GEN-LINE:|104-getter|1|104-postInit
 // write post-init user code here
}//GEN-BEGIN:|104-getter|2|
return cmdServerStandingsExit;
}
//</editor-fold>//GEN-END:|104-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerStandingsMessages ">//GEN-BEGIN:|107-getter|0|107-preInit
/**
 * Returns an initiliazed instance of cmdServerStandingsMessages component.
 * @return the initialized component instance
 */
public Command getCmdServerStandingsMessages () {
if (cmdServerStandingsMessages == null) {//GEN-END:|107-getter|0|107-preInit
 // write pre-init user code here
cmdServerStandingsMessages = new Command ("Msg.", "Messages", Command.OK, 0);//GEN-LINE:|107-getter|1|107-postInit
 // write post-init user code here
}//GEN-BEGIN:|107-getter|2|
return cmdServerStandingsMessages;
}
//</editor-fold>//GEN-END:|107-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cmdServerMessagesStandings ">//GEN-BEGIN:|110-getter|0|110-preInit
/**
 * Returns an initiliazed instance of cmdServerMessagesStandings component.
 * @return the initialized component instance
 */
public Command getCmdServerMessagesStandings () {
if (cmdServerMessagesStandings == null) {//GEN-END:|110-getter|0|110-preInit
 // write pre-init user code here
cmdServerMessagesStandings = new Command ("Stand.", "Standings", Command.OK, 0);//GEN-LINE:|110-getter|1|110-postInit
 // write post-init user code here
}//GEN-BEGIN:|110-getter|2|
return cmdServerMessagesStandings;
}
//</editor-fold>//GEN-END:|110-getter|2|

//<editor-fold defaultstate="collapsed" desc=" Generated Getter: cgServerSetupPlayBackgroundMusic ">//GEN-BEGIN:|112-getter|0|112-preInit
/**
 * Returns an initiliazed instance of cgServerSetupPlayBackgroundMusic component.
 * @return the initialized component instance
 */
public ChoiceGroup getCgServerSetupPlayBackgroundMusic () {
if (cgServerSetupPlayBackgroundMusic == null) {//GEN-END:|112-getter|0|112-preInit
 // write pre-init user code here
cgServerSetupPlayBackgroundMusic = new ChoiceGroup ("Play background music", Choice.MULTIPLE);//GEN-BEGIN:|112-getter|1|112-postInit
cgServerSetupPlayBackgroundMusic.append ("Play background music", null);
cgServerSetupPlayBackgroundMusic.setSelectedFlags (new boolean[] { false });
cgServerSetupPlayBackgroundMusic.setFont (0, null);//GEN-END:|112-getter|1|112-postInit
 // write post-init user code here
}//GEN-BEGIN:|112-getter|2|
return cgServerSetupPlayBackgroundMusic;
}
//</editor-fold>//GEN-END:|112-getter|2|

    /**
     * Returns a display instance.
     * @return the display instance.
     */
    public Display getDisplay () {
        return Display.getDisplay(this);
    }

    /**
     * Exits MIDlet.
     */
    public void exitMIDlet() {
        stopBackgroundMusic();
        
        switchDisplayable (null, null);
        destroyApp(true);
        notifyDestroyed();
    }

    /**
     * Called when MIDlet is started.
     * Checks whether the MIDlet have been already started and initialize/starts or resumes the MIDlet.
     */
    public void startApp() {
        if (midletPaused) {
            resumeMIDlet ();
        } else {
            initialize ();
            startMIDlet ();
        }
        midletPaused = false;
    }

    /**
     * Called when MIDlet is paused.
     */
    public void pauseApp() {
        midletPaused = true;
        
        stopBackgroundMusic();
    }

    /**
     * Called to signal the MIDlet to terminate.
     * @param unconditional if true, then the MIDlet has to be unconditionally terminated and all resources has to be released.
     */
    public void destroyApp(boolean unconditional) {
    }

    public void textReceived(Object sender, String textMessage) {
        if( sender instanceof PokerServer ) {
            Form serverMessages = getFrmServerMessages();
            if( serverMessages.size() >= numberOfTextMessagesToDisplay )
            {
                StringItem stringItemToMove = (StringItem)serverMessages.get(0);
                serverMessages.delete(0);                   // Delete the topmost string item from the form.
                stringItemToMove.setText(textMessage);
                serverMessages.append(stringItemToMove);    // Append the previously topmost string item at the bottom of the form.
            }
            else
            {
                StringItem newMessage = new StringItem(null, textMessage);
                newMessage.setLayout(StringItem.LAYOUT_DEFAULT | StringItem.LAYOUT_NEWLINE_BEFORE | StringItem.LAYOUT_NEWLINE_AFTER);
                serverMessages.append( newMessage );
            }
        }
        else if( sender instanceof PokerClientBase ) {
            Form clientMessages = getFrmClientMessages();
            if( clientMessages.size() >= numberOfTextMessagesToDisplay )
            {
                StringItem stringItemToMove = (StringItem)clientMessages.get(0);
                clientMessages.delete(0);                   // Delete the topmost string item from the form.
                stringItemToMove.setText(textMessage);
                clientMessages.append(stringItemToMove);    // Append the previously topmost string item at the bottom of the form.
            }
            else
            {
                StringItem newMessage = new StringItem(null, textMessage);
                newMessage.setLayout(StringItem.LAYOUT_DEFAULT | StringItem.LAYOUT_NEWLINE_BEFORE | StringItem.LAYOUT_NEWLINE_AFTER);
                clientMessages.append( newMessage );
            }
        }
    }

    public void threadMessageEvent(Thread thread, Object message) {
    }

    public void threadFinishedEvent(Thread thread) {
        if( thread instanceof PokerServer ) {
            System.out.println("Poker server thread ended.");
            PokerServer server = (PokerServer)thread;
            setFinalResults( server.getFinalResult() );
            switchDisplayable(null, getLstFinalResult());
            
            stopBackgroundMusic();
        }
        else if( thread instanceof PokerClientBase ) {
            System.out.println("Poker client thread ended.");
            PokerClientBase client = (PokerClientBase)thread;
            setFinalResults( client.getFinalResult() );
            switchDisplayable(null, getLstFinalResult());
        }
    }

    private void setFinalResults(IForwardIterator resultIterator) {
        List resultList = getLstFinalResult();
        resultList.deleteAll();
        for (int place = 1; resultIterator.hasNext(); ++place) {
            PlayerResult player = (PlayerResult) resultIterator.next();
            resultList.append("" + place + " " + player.getName() + " " + player.getPlayedRounds() + " " + player.getRemainingChips(), null);
        }
    }

    private IGameObserver getCanvasServerGamePlayObserver() {
        return new IGameObserver() {
            PokerGamePlayCanvas gamePlayCanvas = getCanvasPokerGamePlay();

            public void Standing(Object source, String playerName, int chipCount) {
                gamePlayCanvas.setPlayerStanding(playerName, chipCount);
            }

            public void Hand(Object source, String playerName, Hand hand) {
                gamePlayCanvas.setPlayerHand(playerName, hand);
            }
        };
    }

    private PokerGamePlayCanvas getCanvasPokerGamePlay() {
        if( canvasPokerGamePlay == null )
        {
            canvasPokerGamePlay = new PokerGamePlayCanvas();
            canvasPokerGamePlay.addCommand(getCmdPokerGamePlayMessages());
            canvasPokerGamePlay.setCommandListener(this);
        }
        return canvasPokerGamePlay;
    }
    private Command getCmdPokerGamePlayMessages() {
        if( cmdPokerStandingsMessages == null )
        {
            cmdPokerStandingsMessages = new Command ("Msg.", "Messages", Command.OK, 0);
        }
        return cmdPokerStandingsMessages;
    }

    private void loadBackgroundMusic() {
        try
        {
            InputStream is = getClass().getResourceAsStream(BACKGROUNDMUSIC_FILENAME);
            backgroundMusicPlayer = Manager.createPlayer(is, "audio/midi");
            backgroundMusicPlayer.prefetch();
            backgroundMusicPlayer.setLoopCount(-1);
        }
        catch (IOException ioe)
        {
            System.err.println("Failed loading background music. (I/O exception.)");
            ioe.printStackTrace();
        }
        catch (MediaException me)
        {
            System.err.println("Failed loading background music. (Media exception.)");
            me.printStackTrace();
        }
    }
    private void startBackgroundMusic() {
        if( backgroundMusicPlayer != null )
        {
            try {
                backgroundMusicPlayer.start();
            } catch( Exception exc ) {
                exc.printStackTrace();
            }
        }
    }
    private void stopBackgroundMusic() {
        if( backgroundMusicPlayer != null )
        {
            try {
                backgroundMusicPlayer.stop();
            } catch( Exception e ) {
                e.printStackTrace();
            }
        }
    }
}
