/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.Card;
import ca.ualberta.cs.poker.Hand;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Vector;
import javax.microedition.lcdui.Font;
import javax.microedition.lcdui.Graphics;
import javax.microedition.lcdui.Image;
import javax.microedition.lcdui.game.GameCanvas;
import javax.microedition.lcdui.game.Sprite;

/**
 * Displays the current standings of a poker game on a canvas.
 * @author Tobias Persson
 */
public class PokerGamePlayCanvas extends GameCanvas {
    private class PlayerStandingData {
        String playerName;
        int chipCount;
        Hand hand;
        
        public PlayerStandingData(String playerName, int chipCount, Hand hand) {
            this.playerName = playerName;
            this.chipCount = chipCount;
            this.hand = hand;
        }
    }

    private static final String     BACKGROUND_IMAGE_FILENAME   = "/gamebackground.png";
    private static final Image      BACKGROUND_IMAGE;

    private static final String     COIN_IMAGE_FILENAME         = "/coin1_15x11.png";
    private static final int        COIN_WIDTH                  = 15;
    private static final int        COIN_HEIGHT                 = 11;
    private static final int        COIN_OVERLAP_OFFSET         = 4;
    private static final Image[]    COIN_IMAGES                 = new Image[6]; // Different parts of the image COIN_IMAGE_FILENAME.
    private static final int[]      COIN_VALUES                 = {1, 5, 10, 25, 50, 100}; // Should match the values in the images in coinImages.
    private static final int[]      COIN_GROUP_X_OFFSET         = { 31,  5, 52, 132, 179};
    private static final int[]      COIN_GROUP_Y_OFFSET         = {162, 93, 31,  31,  93};
    private static final int[]      COIN_STACK_X_OFFSET         = { 0, 16, 32,  9, 25, 41};
    private static final int[]      COIN_STACK_Y_OFFSET         = {51, 47, 51, 61, 65, 61};

    private static final int        NAME_COLOR_NORMAL           = 0xFFFF00;
    private static final int        NAME_COLOR_BROKE            = 0xFF0000;
    private static final int[]      NAME_X_OFFSET               = {  2,  37, 37, 189, 204};
    private static final int[]      NAME_Y_OFFSET               = {199, 113, 36,  50, 128};
    private static final int[]      NAME_ANCHOR                 = { Graphics.LEFT  | Graphics.BOTTOM,
                                                                    Graphics.LEFT  | Graphics.BOTTOM,
                                                                    Graphics.LEFT  | Graphics.BOTTOM,
                                                                    Graphics.RIGHT | Graphics.BOTTOM,
                                                                    Graphics.RIGHT | Graphics.BOTTOM };

    private static final String     BIG_CARDS_SPADES_FILENAME   = "/cards_spades_38x56.png";
    private static final String     BIG_CARDS_HEARTS_FILENAME   = "/cards_hearts_38x56.png";
    private static final String     BIG_CARDS_CLUBS_FILENAME    = "/cards_clubs_38x56.png";
    private static final String     BIG_CARDS_DIAMONDS_FILENAME = "/cards_diamonds_38x56.png";
    private static final int        BIG_CARD_WIDTH              = 38;
    private static final int        BIG_CARD_HEIGHT             = 56;
    private static final Image[]    BIG_CARDS_SPADES_IMAGES     = new Image[13];
    private static final Image[]    BIG_CARDS_HEARTS_IMAGES     = new Image[13];
    private static final Image[]    BIG_CARDS_CLUBS_IMAGES      = new Image[13];
    private static final Image[]    BIG_CARDS_DIAMONDS_IMAGES   = new Image[13];
    private static final String     CARDS_SPADES_FILENAME       = "/cards_spades_19x28.png";
    private static final String     CARDS_HEARTS_FILENAME       = "/cards_hearts_19x28.png";
    private static final String     CARDS_CLUBS_FILENAME        = "/cards_clubs_19x28.png";
    private static final String     CARDS_DIAMONDS_FILENAME     = "/cards_diamonds_19x28.png";
    private static final int        CARD_WIDTH                  = 19;
    private static final int        CARD_HEIGHT                 = 28;
    private static final Image[]    CARDS_SPADES_IMAGES         = new Image[13];
    private static final Image[]    CARDS_HEARTS_IMAGES         = new Image[13];
    private static final Image[]    CARDS_CLUBS_IMAGES          = new Image[13];
    private static final Image[]    CARDS_DIAMONDS_IMAGES       = new Image[13];
    private static final int[][][]  CARD_POSITIONS              = { {{ 88,184}, {103,184}, {118,184}, {133,184}, {148,184}},    // x and y values for the first position,
                                                                    {{ 64,113}, { 79,113}, { 94,113}, {109,113}, {124,113}},    // x and y values for the second position,
                                                                    {{ 15, 21}, { 30, 36}, { 15, 51}, { 30, 66}, { 15, 81}},    // etc.
                                                                    {{191, 21}, {206, 36}, {191, 51}, {206, 66}, {191, 81}},
                                                                    {{106,146}, {121,146}, {136,146}, {151,146}, {166,146}} };

    private Vector                  playerStandings             = new Vector(5); // 5 is the default size of the vector, but it is growable.
    private Object                  lock                        = new Object(); // The synchronization lock.

    private volatile Runnable       repainter                   = null;
    
    Graphics g;
    
    // Static constructor.
    static
    {
        // Background image
        Image backgroundImage = null;
        try {
            backgroundImage = Image.createImage(BACKGROUND_IMAGE_FILENAME);
        } catch(IOException ioe) {
            System.err.println("Error loading background image.");
            ioe.printStackTrace();
        }
        BACKGROUND_IMAGE = backgroundImage; // It is not possible to use the BACKGROUND_IMAGE in the try/catch statement above.

        // Coins
        try {
            Image allCoinsImage = Image.createImage(COIN_IMAGE_FILENAME);
            for( int i = 0; i < COIN_IMAGES.length; ++i)
                COIN_IMAGES[i] = Image.createImage(allCoinsImage, 0, i*COIN_HEIGHT, COIN_WIDTH, COIN_HEIGHT, Sprite.TRANS_NONE );
        } catch(IOException ioe) {
            System.err.println("Error loading coin image.");
            ioe.printStackTrace();
        }
        
        // Big cards
        try {
            Image allSpadesImage = Image.createImage(BIG_CARDS_SPADES_FILENAME);
            for( int i = 0; i < BIG_CARDS_SPADES_IMAGES.length; ++i )
                BIG_CARDS_SPADES_IMAGES[i] = Image.createImage(allSpadesImage, 0, i*BIG_CARD_HEIGHT, BIG_CARD_WIDTH, BIG_CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading big spades image.");
            ioe.printStackTrace();
        }
        try {
            Image allHeartsImage = Image.createImage(BIG_CARDS_HEARTS_FILENAME);
            for( int i = 0; i < BIG_CARDS_HEARTS_IMAGES.length; ++i )
                BIG_CARDS_HEARTS_IMAGES[i] = Image.createImage(allHeartsImage, 0, i*BIG_CARD_HEIGHT, BIG_CARD_WIDTH, BIG_CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading big hearts image.");
            ioe.printStackTrace();
        }
        try {
            Image allClubsImage = Image.createImage(BIG_CARDS_CLUBS_FILENAME);
            for( int i = 0; i < BIG_CARDS_CLUBS_IMAGES.length; ++i )
                BIG_CARDS_CLUBS_IMAGES[i] = Image.createImage(allClubsImage, 0, i*BIG_CARD_HEIGHT, BIG_CARD_WIDTH, BIG_CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading big clubs image.");
            ioe.printStackTrace();
        }
        try {
            Image allDiamondsImage = Image.createImage(BIG_CARDS_DIAMONDS_FILENAME);
            for( int i = 0; i < BIG_CARDS_DIAMONDS_IMAGES.length; ++i )
                BIG_CARDS_DIAMONDS_IMAGES[i] = Image.createImage(allDiamondsImage, 0, i*BIG_CARD_HEIGHT, BIG_CARD_WIDTH, BIG_CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading diamonds image.");
            ioe.printStackTrace();
        }

        // Normal cards
        try {
            Image allSpadesImage = Image.createImage(CARDS_SPADES_FILENAME);
            for( int i = 0; i < CARDS_SPADES_IMAGES.length; ++i )
                CARDS_SPADES_IMAGES[i] = Image.createImage(allSpadesImage, 0, i*CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading spades image.");
            ioe.printStackTrace();
        }
        try {
            Image allHeartsImage = Image.createImage(CARDS_HEARTS_FILENAME);
            for( int i = 0; i < CARDS_HEARTS_IMAGES.length; ++i )
                CARDS_HEARTS_IMAGES[i] = Image.createImage(allHeartsImage, 0, i*CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading hearts image.");
            ioe.printStackTrace();
        }
        try {
            Image allClubsImage = Image.createImage(CARDS_CLUBS_FILENAME);
            for( int i = 0; i < CARDS_CLUBS_IMAGES.length; ++i )
                CARDS_CLUBS_IMAGES[i] = Image.createImage(allClubsImage, 0, i*CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading clubs image.");
            ioe.printStackTrace();
        }
        try {
            Image allDiamondsImage = Image.createImage(CARDS_DIAMONDS_FILENAME);
            for( int i = 0; i < CARDS_DIAMONDS_IMAGES.length; ++i )
                CARDS_DIAMONDS_IMAGES[i] = Image.createImage(allDiamondsImage, 0, i*CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT, Sprite.TRANS_NONE );
        } catch( IOException ioe ) {
            System.err.println("Error loading diamonds image.");
            ioe.printStackTrace();
        }
    }
    
    public PokerGamePlayCanvas()
    {
        super(false);

        g = this.getGraphics();
        
        // Switch to a small font.
        Font standardFont = g.getFont();
        g.setFont( Font.getFont(standardFont.getFace(), standardFont.getStyle(), Font.SIZE_SMALL) );
        
        drawBackground(g);
        flushGraphics();
    }

    public void setPlayerStanding(String playerName, int chipCount) {
        synchronized(lock)
        {
            boolean playerFound = false;
            for( int i = 0; i < playerStandings.size(); ++i )
            {
                PlayerStandingData currentData = (PlayerStandingData)playerStandings.elementAt(i);
                if( currentData.playerName.equals(playerName) )
                {
                    currentData.chipCount = chipCount;
                    playerFound = true;
                    break;
                }
            }
            if( !playerFound )
            {
                // No player found, so add the new player.
                playerStandings.addElement( new PlayerStandingData(playerName, chipCount, null) );
            }
        }
        requestRepaint();
    }

    public void setPlayerHand(String playerName, Hand hand) {
        synchronized(lock)
        {
            boolean playerFound = false;
            for( int i = 0; i < playerStandings.size(); ++i )
            {
                PlayerStandingData currentData = (PlayerStandingData)playerStandings.elementAt(i);
                if( currentData.playerName.equals(playerName) )
                {
                    currentData.hand = hand;
                    playerFound = true;
                    break;
                }
            }
            if( !playerFound )
            {
                // No player found, so add the new player.
                playerStandings.addElement( new PlayerStandingData(playerName, 0, hand) );
            }
        }
        requestRepaint();
    }

    private void requestRepaint() {
        if( repainter == null )
        {
            synchronized(lock)
            {
                if( repainter == null )
                {
                    repainter = new Runnable() {
                        public void run() {
                            drawGame(g);
                            flushGraphics();
                            repaint();
                            repainter = null;
                        }
                    };
                    Thread thread = new Thread(repainter);
                    thread.setPriority(Thread.MAX_PRIORITY);
                    thread.start();
                }
            }
        }
    }
    
    /**
     * Draws the background.
     * @param g The graphics object to use when drawing the background.
     */
    private void drawBackground(Graphics g) {
        g.drawImage(BACKGROUND_IMAGE, 0, 0, Graphics.LEFT | Graphics.TOP);
    }

    private void drawGame(Graphics g) {
        System.out.println("PokerGamePlayCanvas.drawGame: Started...");
        // Draw the background image.
        drawBackground(g);

        synchronized(lock)
        {
            for( int i = 0; i < playerStandings.size(); ++i )
            {
                PlayerStandingData currentData = (PlayerStandingData)playerStandings.elementAt(i);

                // Draw the amount of chips.
                drawCoinStack(g, i, currentData.chipCount);
                // Draw the cards.
                drawCards(g, i, currentData.hand);
                // Draw the name.
                g.setColor( currentData.chipCount > 0 ? NAME_COLOR_NORMAL : NAME_COLOR_BROKE );
                g.drawString( currentData.playerName, NAME_X_OFFSET[i], NAME_Y_OFFSET[i], NAME_ANCHOR[i] );
            }
        }
        System.out.println("PokerGamePlayCanvas.drawGame: ...ended.");
    }

    private void drawCoinStack(Graphics g, int playerPositionIndex, int totalChipCount) {
        final int GROUP_X = COIN_GROUP_X_OFFSET[playerPositionIndex];
        final int GROUP_Y = COIN_GROUP_Y_OFFSET[playerPositionIndex];

        int[] numberOfCoins = new int[COIN_VALUES.length];

        // Go from the most valuable to the least valuable coin.
        for( int coinIndex = COIN_VALUES.length-1; coinIndex >= 0; --coinIndex)
        {
            numberOfCoins[coinIndex] = totalChipCount / COIN_VALUES[coinIndex];
            totalChipCount -= numberOfCoins[coinIndex] * COIN_VALUES[coinIndex];
        }
        // Go from the least valuable to the most valuable coin.
        for( int coinIndex = 0; coinIndex < numberOfCoins.length; ++coinIndex )
        {
            int x = GROUP_X + COIN_STACK_X_OFFSET[coinIndex];
            int y = GROUP_Y + COIN_STACK_Y_OFFSET[coinIndex];

            for( int stackIndex = 0; stackIndex < numberOfCoins[coinIndex]; ++stackIndex, y -= COIN_OVERLAP_OFFSET )
            {
                g.drawImage(COIN_IMAGES[coinIndex], x, y, Graphics.LEFT | Graphics.BOTTOM);
            }
        }
    }
   
    private void drawCards(Graphics g, int playerPositionIndex, Hand hand) {
        if( hand == null )
            return; // Nothing to draw.

        final int[][] cardPositions = CARD_POSITIONS[playerPositionIndex];
        
        for( int i = 0; i < hand.size() && i < cardPositions.length; ++i )
        {
            // WARNING: Hand.getCard(index) uses a one-based, not zero-based, index.
            Card currentCard = hand.getCard(i+1);
            int suit = currentCard.getSuit();
            Image[] suitImages =    playerPositionIndex == 0
                                    ? ( suit == Card.SPADES     ?   BIG_CARDS_SPADES_IMAGES :
                                        suit == Card.HEARTS     ?   BIG_CARDS_HEARTS_IMAGES :
                                        suit == Card.CLUBS      ?   BIG_CARDS_CLUBS_IMAGES :
                                        suit == Card.DIAMONDS   ?   BIG_CARDS_DIAMONDS_IMAGES :
                                                                    null )
                                    : ( suit == Card.SPADES     ?   CARDS_SPADES_IMAGES :
                                        suit == Card.HEARTS     ?   CARDS_HEARTS_IMAGES :
                                        suit == Card.CLUBS      ?   CARDS_CLUBS_IMAGES :
                                        suit == Card.DIAMONDS   ?   CARDS_DIAMONDS_IMAGES :
                                                                    null );
            int rank  = currentCard.getRank();
            // WARNING: The rank starts with two as rank zero and goes up to ace as rank 12.
            // The images starts with ace as the first image and goes up to king as last image.
            int imageIndex = rank != Card.ACE ? rank + 1 : 0;

            g.drawImage( suitImages[imageIndex], cardPositions[i][0], cardPositions[i][1], Graphics.LEFT | Graphics.TOP );
        }
    }
}
