/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.*;
import java.util.Hashtable;

/**
 * A class acting as a poker client. It extends the base class {@link PokerClientBase}
 * and is intended to be reviewed and/or changed by students.
 * @author Tobias Persson
 */
public class PokerClient extends PokerClientBase {
    private String name;
    private Hand hand;
    private CardRank Ranker;
    private int[] CardsLeft;
    int[] CardRepHand = new int[5];
    double BestHandValue = 0;
    int[] CardsToThrow;
    int CurrentRound = 0;
    /* Keep track of number of actions in this round */
    int NoOfActions = 0;
    int PlayersFolded = 0;
    boolean CardsThrown;
    Hashtable Players;
    Player Raised;
    private int Ante;
    private int CHIP_VALUE;
    private long[] Bionomial = { 47, 1081, 16215, 178365, 1533939 };
    private int TOTAL_MONEY;
    private boolean Evaluated = false;

    private int[] RankBin = { 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096 };
    private int[] Suit = { 1, 2, 4, 8 };
    private int[] RankDec = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
    private int[] CardPrime = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 };
    private int[] CardRep = { ( RankBin[0] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[0] << 8 ) + CardPrime[0], /* Clubs */
                              ( RankBin[1] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[1] << 8 ) + CardPrime[1],
                              ( RankBin[2] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[2] << 8 ) + CardPrime[2],
                              ( RankBin[3] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[3] << 8 ) + CardPrime[3],
                              ( RankBin[4] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[4] << 8 ) + CardPrime[4],
                              ( RankBin[5] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[5] << 8 ) + CardPrime[5],
                              ( RankBin[6] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[6] << 8 ) + CardPrime[6],
                              ( RankBin[7] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[7] << 8 ) + CardPrime[7],
                              ( RankBin[8] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[8] << 8 ) + CardPrime[8],
                              ( RankBin[9] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[9] << 8 ) + CardPrime[9],
                              ( RankBin[10] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[10] << 8 ) + CardPrime[10],
                              ( RankBin[11] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[11] << 8 ) + CardPrime[11],
                              ( RankBin[12] << 16 ) + ( Suit[3] << 12 ) + ( RankDec[12] << 8 ) + CardPrime[12],
                              ( RankBin[0] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[0] << 8 ) + CardPrime[0], /* Diamonds */
                              ( RankBin[1] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[1] << 8 ) + CardPrime[1],
                              ( RankBin[2] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[2] << 8 ) + CardPrime[2],
                              ( RankBin[3] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[3] << 8 ) + CardPrime[3],
                              ( RankBin[4] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[4] << 8 ) + CardPrime[4],
                              ( RankBin[5] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[5] << 8 ) + CardPrime[5],
                              ( RankBin[6] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[6] << 8 ) + CardPrime[6],
                              ( RankBin[7] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[7] << 8 ) + CardPrime[7],
                              ( RankBin[8] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[8] << 8 ) + CardPrime[8],
                              ( RankBin[9] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[9] << 8 ) + CardPrime[9],
                              ( RankBin[10] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[10] << 8 ) + CardPrime[10],
                              ( RankBin[11] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[11] << 8 ) + CardPrime[11],
                              ( RankBin[12] << 16 ) + ( Suit[2] << 12 ) + ( RankDec[12] << 8 ) + CardPrime[12],
                              ( RankBin[0] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[0] << 8 ) + CardPrime[0], /* Hearts */
                              ( RankBin[1] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[1] << 8 ) + CardPrime[1],
                              ( RankBin[2] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[2] << 8 ) + CardPrime[2],
                              ( RankBin[3] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[3] << 8 ) + CardPrime[3],
                              ( RankBin[4] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[4] << 8 ) + CardPrime[4],
                              ( RankBin[5] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[5] << 8 ) + CardPrime[5],
                              ( RankBin[6] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[6] << 8 ) + CardPrime[6],
                              ( RankBin[7] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[7] << 8 ) + CardPrime[7],
                              ( RankBin[8] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[8] << 8 ) + CardPrime[8],
                              ( RankBin[9] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[9] << 8 ) + CardPrime[9],
                              ( RankBin[10] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[10] << 8 ) + CardPrime[10],
                              ( RankBin[11] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[11] << 8 ) + CardPrime[11],
                              ( RankBin[12] << 16 ) + ( Suit[1] << 12 ) + ( RankDec[12] << 8 ) + CardPrime[12],
                              ( RankBin[0] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[0] << 8 ) + CardPrime[0], /* Spades */
                              ( RankBin[1] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[1] << 8 ) + CardPrime[1],
                              ( RankBin[2] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[2] << 8 ) + CardPrime[2],
                              ( RankBin[3] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[3] << 8 ) + CardPrime[3],
                              ( RankBin[4] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[4] << 8 ) + CardPrime[4],
                              ( RankBin[5] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[5] << 8 ) + CardPrime[5],
                              ( RankBin[6] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[6] << 8 ) + CardPrime[6],
                              ( RankBin[7] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[7] << 8 ) + CardPrime[7],
                              ( RankBin[8] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[8] << 8 ) + CardPrime[8],
                              ( RankBin[9] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[9] << 8 ) + CardPrime[9],
                              ( RankBin[10] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[10] << 8 ) + CardPrime[10],
                              ( RankBin[11] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[11] << 8 ) + CardPrime[11],
                              ( RankBin[12] << 16 ) + ( Suit[0] << 12 ) + ( RankDec[12] << 8 ) + CardPrime[12]
                            };

    /**
     * Creates a new instance of <code>PokerClient</code>.
     * @param server    the address of the poker server.
     * @param port      the port used by the poker server.
     */
    public PokerClient(String server, int port) {
        super(server, port);
        Ranker = new CardRank();
        Players = new Hashtable();
        Ranker.GenerateHash();
    }

    /**
     * Gets the name of the player.
     * @return  The name of the player as a single word without space. <code>null</code> is not a valid answer.
     */
    protected String queryPlayerName() {
        // NOTE
        // You typically return a constant (final) string here, not something
        // generated dynamically and/or randomly as is done now. This is only
        // to give different clients different names during testing.
        if( name == null )
            name = "Tester";
        return name;
    }

    /**
     * Called when a new round begins.
     * @param round the round number (increased for each new round).
     */
    protected void infoNewRound(int round) {
        notifyTextReceivers("Starting round #"+round);
        this.CurrentRound = round;
        this.CardsThrown = false;
        PlayersFolded = 0;
    }

    /**
     * Called when the poker server informs that the game is completed.
     */
    protected void infoGameOver() {
        ((Player)Players.get( "Tester" )).Aggresitivity = PlayStyle.CalcPlayStyle(((Player)Players.get( "Tester" )), this.CurrentRound );
        ((Player)Players.get( "Tester" )).Aggresitivity = PlayStyle.OpenCheckRatio(((Player)Players.get( "Tester" )), this.CurrentRound );
        notifyTextReceivers("The game is over.");
    }

    /**
     * Called when the server informs the players how many chips a player has.
     * @param playerName    the name of a player.
     * @param chips         the amount of chips the player has.
     */
    protected void infoPlayerChips(String playerName, int chips) {
        notifyTextReceivers("The player '"+playerName+"' has "+chips+" chips.");
        if( this.CurrentRound == 1 )
        {
            /* Create a new object of the player and give him a position */
            Players.put( playerName, new Player( playerName, Players.size() ) );
            CHIP_VALUE = chips;
        }
        if ( Players.get( playerName ) != null )
        {
            if( chips == 0 )
            {
                Players.remove( playerName );
                CHIP_VALUE = TOTAL_MONEY / Players.size();
            }
            else
            {
                ((Player)Players.get( playerName )).Chips = chips;
                ((Player)(Players.get( playerName ))).InRound = true;
            }
        }
    }
    
    /**
     * Called when the ante has changed.
     * @param ante  the new value of the ante.
     */
    protected void infoAnteChanged(int ante) {
        notifyTextReceivers("The ante is "+ante);
        this.Ante = ante;
    }

    /**
     * Called when a player had to do a forced bet (putting the ante in the pot).
     * @param playerName    the name of the player forced to do the bet.
     * @param forcedBet     the number of chips forced to bet.
     */
    protected void infoForcedBet(String playerName, int forcedBet) {
        notifyTextReceivers("Player "+playerName +" made a forced bet of "+forcedBet + " chips.");
    }
    
    /**
     * Called when a player opens a betting round.
     * @param playerName        the name of the player that opens.
     * @param openBet           the amount of chips the player has put into the pot.
     */
    protected void infoPlayerOpen(String playerName, int openBet) {
        notifyTextReceivers("Player "+playerName +" opened, has put "+openBet+" chips into the pot.");
        ((Player)Players.get( playerName )).NoOfOpens++;
        ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_OPEN;
        NoOfActions = 1;
        Raised = ((Player)Players.get( playerName ));
    }

    /**
     * Called when a player checks.
     * @param playerName        the name of the player that checks.
     */
    protected void infoPlayerCheck(String playerName) {
        notifyTextReceivers("Player "+playerName +" checked.");
        ((Player)Players.get( playerName )).NoOfChecks++;
        ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_CHECK;
        NoOfActions++;
    }

    /**
     * Called when a player raises.
     * @param playerName        the name of the player that raises.
     * @param amountRaisedTo    the amount of chips the player raised to.
     */
    protected void infoPlayerRaise(String playerName, int amountRaisedTo) {
        notifyTextReceivers("Player "+playerName +" raised to "+amountRaisedTo+" chips.");
        ((Player)Players.get( playerName )).NoOfRaises++;
        ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_RAISE;
        NoOfActions = 1;
        Raised = ((Player)Players.get( playerName ));
    }

    /**
     * Called when a player calls.
     * @param playerName        the name of the player that calls.
     */
    protected void infoPlayerCall(String playerName) {
        notifyTextReceivers("Player "+playerName +" called.");
        ((Player)Players.get( playerName )).NoOfCalls++;
        ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_CALL;
        NoOfActions++;
    }

    /**
     * Called when a player folds.
     * @param playerName        the name of the player that folds.
     */
    protected void infoPlayerFold(String playerName) {
        notifyTextReceivers("Player "+playerName +" folded.");
        ((Player)Players.get( playerName )).NoOfFolds++;
        ((Player)Players.get( playerName )).InRound = false;
        ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_FOLD;
        PlayersFolded++;
    }

    /**
     * Called when a player goes all-in.
     * @param playerName        the name of the player that goes all-in.
     * @param allInChipCount    the amount of chips the player has in the pot and goes all-in with.
     */
    protected void infoPlayerAllIn(String playerName, int allInChipCount) {
        notifyTextReceivers("Player "+playerName +" goes all-in with a pot of "+allInChipCount+" chips.");
        Player p = ((Player)Players.get( playerName ));
        if( ((Player)Players.get( playerName )).Chips >= this.Ante )
        {
            ((Player)Players.get( playerName )).NoOfAllIns++;
            NoOfActions = 1;
            Raised = ((Player)Players.get( playerName ));
            ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_ALLIN;
        }
        else
        {
        /* If player goes all in when his chips < ante that means that it
           was a forced all in, don't count this as an all in */
        ((Player)Players.get( playerName )).LastAction = BettingAnswer.ACTION_OPEN;
        }
    }

    /**
     * Called when a player has exchanged (thrown away and drawn new) cards.
     * @param playerName        the name of the player that has exchanged cards.
     * @param cardCount         the number of cards exchanged.
     */
    protected void infoPlayerDraw(String playerName, int cardCount) {
        notifyTextReceivers("Player "+playerName +" exchanged "+cardCount+" cards.");
        ((Player)Players.get( playerName )).CardsThrown = cardCount;
    }

    /**
     * Called during the showdown when a player shows his hand.
     * @param playerName        the name of the player whose hand is shown.
     * @param hand              the players hand.
     */
    protected void infoPlayerHand(String playerName, Hand hand) {
        // The hands toString() methods prepends the returned string with space.
        notifyTextReceivers("Player "+playerName+" has this hand:"+hand+" ("+getHandName(hand)+", category #"+getHandCategory(hand)+")");
    }

    /**
     * Called during the showdown when a players undisputed win is reported.
     * @param playerName    the name of the player whose undisputed win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundUndisputedWin(String playerName, int winAmount) {
        notifyTextReceivers("Player "+playerName+" won "+winAmount+" chips undisputed.");
    }

    /**
     * Called during the showdown when a players win is reported. If a player does not win anything,
     * this method is not called.
     * @param playerName    the name of the player whose win is anounced.
     * @param winAmount     the amount of chips the player won.
     */
    protected void infoRoundResult(String playerName, int winAmount) {
        notifyTextReceivers("Player "+playerName+" won " + winAmount + " chips.");
    }

    /**
     * Called during the betting phases of the game when the player needs to decide what open
     * action to choose.
     * @param minimumPotAfterOpen   the total minimum amount of chips to put into the pot if the answer action is
     *                              {@link BettingAnswer#ACTION_OPEN}.
     * @param playersCurrentBet     the amount of chips the player has already put into the pot (dure to the forced bet).
     * @param playersRemainingChips the number of chips the player has not yet put into the pot.
     * @return                      An answer to the open query. The answer action must be one of
     *                              {@link BettingAnswer#ACTION_OPEN}, {@link BettingAnswer#ACTION_ALLIN} or
     *                              {@link BettingAnswer#ACTION_CHECK }. If the action is open, the answers
     *                              amount of chips in the anser must be between <code>minimumPotAfterOpen</code>
     *                              and the players total amount of chips (the amount of chips alrady put into
     *                              pot plus the remaining amount of chips).
     */
    protected BettingAnswer queryOpenAction(int minimumPotAfterOpen, int playersCurrentBet, int playersRemainingChips) {
        /* Card rank ( BestHandValue ):
            > 0    - high card
            > 0.18 - one pair
            > 0.56 - two pair
            > 0.67 - three-kind
            > 0.79 - straights
            > 0.79 - flushes
            > 0.96 - full house
            > 0.98 - four-kind
            > 0.999 - straight-flushes
         */

        notifyTextReceivers("Player requested to choose an opening action.");

        while( Evaluated == false );

        /* Calculate number of players left in the betting round */
        int PlayersLeftInBettingRound = Players.size() - NoOfActions - PlayersFolded;
        int Bet;

        if( ( minimumPotAfterOpen-playersCurrentBet ) >= playersRemainingChips )
        {
            /* No money left to bet */
            return new BettingAnswer( BettingAnswer.ACTION_CHECK );
        }
        else
        {
            /* Calculate what we are ready to bet */
            Bet = (int)( ( CHIP_VALUE*( PositionScaling( PlayersLeftInBettingRound ) )*BestHandValue*BestHandValue*BestHandValue ) );
            ////System.out.println( "Chance to open: " + Bet + "  Ante: " + Ante );
            if( Bet <= minimumPotAfterOpen*1.2 )
            {
                /* Check if we dont want to bet the minimum bet */
                return new BettingAnswer( BettingAnswer.ACTION_CHECK );
            }

            if( Bet >= playersRemainingChips )
            {
                /* Not enough money to be what we want to, go all in */

                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
            }
            /* Bet the desired bet! */
            if( this.CardsThrown == false && Bet > Ante )
            {
                /* Don't raise with an insane amount the first opening round */
                return new BettingAnswer( BettingAnswer.ACTION_OPEN, Ante+playersCurrentBet );
            }
            if( this.Players.size() == 2 )
            {
                /* Play more aggressive when two players left */
                return new BettingAnswer( BettingAnswer.ACTION_OPEN, Bet+playersCurrentBet );
            }
            return new BettingAnswer( BettingAnswer.ACTION_OPEN, Bet+playersCurrentBet );
        }

        /*
        switch( random.nextInt() % 3 )
        {
            case 0:     return new BettingAnswer(BettingAnswer.ACTION_CHECK);
            case 1:     return new BettingAnswer(BettingAnswer.ACTION_ALLIN);
            default:    return new BettingAnswer( playersCurrentBet+playersRemainingChips > minimumPotAfterOpen
                                                    ? BettingAnswer.ACTION_OPEN : BettingAnswer.ACTION_CHECK,
                                                  minimumPotAfterOpen + (playersCurrentBet+playersRemainingChips+10>minimumPotAfterOpen ? random.nextInt(10) : 0 ) );
        } */
    }

    /**
     * Called when the player receives cards. The hand contains all cards the player currently holds.
     * @param hand  the hand of cards the player currently holds.
     */
    protected void infoCardsInHand(Hand hand) {
        notifyTextReceivers("The cards in hand is" + hand + ".");
        this.hand = hand;
        BestHandValue = -1;
        NoOfActions = 0;

        /* Generate a list with all cards */
        CardsLeft = new int[52];
        System.arraycopy(CardRep, 0, CardsLeft, 0, 52);

        if( this.CurrentRound == 1 )
        {
            TOTAL_MONEY = CHIP_VALUE * Players.size();
        }

        /* Remove recieved cards from CardsLeft */
        for( int i = 0; i < 5; i++ )
        {
            /* Remove recieved cards from CardsLeft */
            int a = hand.getCard( i+1 ).getRank() + ( hand.getCard(i+1).getSuit() * 13 );
            ////System.out.print("Suit: " + a/13);
            ////System.out.println(" Rank: " + a%13);
            CardsLeft[ hand.getCard( i+1 ).getRank() + ( hand.getCard( i+1 ).getSuit() * 13 ) ] = 0;

            /* Translate the given hand to the local card representation */
            CardRepHand[ i ] = CardRep[ hand.getCard( i+1 ).getRank() + ( hand.getCard( i+1 ).getSuit() * 13 ) ];
        }

        /* Get Rank for our current hand if we have thrown cards*/
        if( CardsThrown == true )
        {
            BestHandValue = 1 - Ranker.rank( CardRepHand )/7462.0;
        }
        else
        {
            /* If we haven't thrown cards yet then only calculate BestHandValue
               if not done before */
            this.ThrowCalculator();
        }

        Evaluated = true;

        //System.out.println( "**********************NEW CARDS******************************" );

    }

    /**
     * Called during the betting phases of the game when the player needs to decide what call/raise
     * action to choose.
     * @param maximumBet                the maximum number of chips one player has already put into the pot.
     * @param minimumAmountToRaiseTo    the minimum amount of chips to bet if the returned answer is {@link BettingAnswer#ACTION_RAISE}.
     * @param playersCurrentBet         the number of chips the player has already put into the pot.
     * @param playersRemainingChips     the number of chips the player has not yet put into the pot.
     * @return                          An answer to the call or raise query. The answer action must be one of
     *                                  {@link BettingAnswer#ACTION_FOLD}, {@link BettingAnswer#ACTION_CALL},
     *                                  {@link BettingAnswer#ACTION_RAISE} or {@link BettingAnswer#ACTION_ALLIN }.
     *                                  If the players number of remaining chips is less than the maximum bet and
     *                                  the players current bet, the call action is not available. If the players
     *                                  number of remaining chips plus the players current bet is less than the minimum
     *                                  amount of chips to raise to, the raise action is not available. If the action
     *                                  is raise, the answers amount of chips is the total amount of chips the player
     *                                  puts into the pot and must be between <code>minimumAmountToRaiseTo</code> and
     *                                  <code>playersCurrentBet+playersRemainingChips</code>.
     */
    protected BettingAnswer queryCallRaiseAction(int maximumBet, int minimumAmountToRaiseTo, int playersCurrentBet, int playersRemainingChips ) {
        /* Card rank ( BestHandValue ):
            > 0    - high card
            > 0.18 - one pair
            > 0.56 - two pair
            > 0.67 - three-kind
            > 0.79 - straights
            > 0.79 - flushes
            > 0.96 - full house
            > 0.98 - four-kind
            > 0.999 - straight-flushes
         */

        notifyTextReceivers("Player requested to choose a call/raise action.");

        while( Evaluated == false );

        int PlayersLeftInBettingRound = Players.size() - NoOfActions - PlayersFolded;
        int Bet;
        double AggrOfRaisPlayer; /* Aggresitivity of the player who raised last */

        AggrOfRaisPlayer = PlayStyle.CalcPlayStyle( Raised, this.CurrentRound );

        if( playersRemainingChips <= ( maximumBet - playersCurrentBet ) )
        {
            /* Not enough money to call */
            //System.out.println( "NOT ENOUGHT MONEY TO CALL" );
            if( ( this.CardsThrown == false ) && ( BestHandValue > 0.5 ) && ( AggrOfRaisPlayer > 0.6 ) )
            {
                /* If it's before card's have been thrown and the raising player
                   is aggresive and we have fairly good cards, then go all in
                   ( might be interesting to calculate numbers of other player checks too.. ) */
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
            }
            else if( ( this.CardsThrown == true ) && ( Raised.CardsThrown >= 3 ) && ( BestHandValue > 0.5 ) )
            {
                /* Cards have been thrown and the raising player has thrown 3 or
                   more cards which shows that he had pair as best before
                   the draw. If we have a pair or better, go all in */
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
            }
            else if( playersRemainingChips <= 0.1*playersCurrentBet )
            {
                /* We already have a lot of money in the pot, risk all of it! */
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
            }

            if( ( this.CardsThrown == true ) && BestHandValue > 0.70 && Raised.CardsThrown != 0 )
            {
                /* Go for it! */
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
            }

            /* Not worth the risk to allin, just fold */
            return new BettingAnswer( BettingAnswer.ACTION_FOLD );
        }
        if( playersRemainingChips <= ( minimumAmountToRaiseTo-playersCurrentBet ) )
        {
            /* Not enough money to raise but we can call or fold */
            //System.out.println( "NOT ENOUGHT MONEY TO RAISE" );
            if( Raised.LastAction == BettingAnswer.ACTION_OPEN )
            {
                /* If an open action brought us here, peek at the open/check ratio
                   of the openening player */

                Bet = (int)( CHIP_VALUE * BestHandValue * this.PositionScaling( PlayersLeftInBettingRound ) * PlayStyle.OpenCheckRatio( Raised, this.CurrentRound ) );

                if( Bet >= ( maximumBet-playersCurrentBet ) )
                {
                    /* Call if confident that we have good cards */
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( BestHandValue*Raised.OpenRatio > 0.65 )
                {
                    /* Don't waste a really good hand */
                    return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                }

                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
            else
            {
                /* A raise or all in action brought us here */
                Bet = (int)( CHIP_VALUE * BestHandValue * this.PositionScaling( PlayersLeftInBettingRound ) * PlayStyle.CalcPlayStyle( Raised, this.CurrentRound ) );

                if( Bet >= ( maximumBet-playersCurrentBet ) )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( BestHandValue*Raised.Aggresitivity > 0.35 )
                {
                    /* Don't waste a really good hand if the raising player
                       always is aggressive. */
                    return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                }

                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
        }
        else
        {
            /* Possible to raise, call or fold */
            //System.out.println( "POSSIBLE TO RAISE NOW" );
            if( Raised.LastAction == BettingAnswer.ACTION_OPEN || Raised.LastAction == BettingAnswer.ACTION_RAISE )
            {
                /* Open or raise */
                if( Raised.LastAction == BettingAnswer.ACTION_OPEN )
                {
                    /* If an open action brought us here, peek at the open/check ratio
                     of the openening player. Scale bet value with the amount the player
                     opened with divided by CHIP_VALUE. This is to avoid a "too high"
                     raise without any reason. An open doesn't have to be very high..*/
                    Bet = (int)( CHIP_VALUE * BestHandValue * BestHandValue * this.PositionScaling( PlayersLeftInBettingRound ) * PlayStyle.OpenCheckRatio( Raised, this.CurrentRound ) );
                    //System.out.println( "Open: " + Bet + "        openCheckRatio: " + (int)PlayStyle.OpenCheckRatio( Raised, this.CurrentRound ) );
                }
                else
                {
                    /* A raise action brought us here, use aggresitivity instead */
                    Bet = (int)( CHIP_VALUE * BestHandValue * BestHandValue * PlayStyle.CalcPlayStyle( Raised, this.CurrentRound ) );
                    //System.out.println( "Raise: " + Bet + "       Player style: " + (int)PlayStyle.CalcPlayStyle( Raised, this.CurrentRound ) );
                }
                if( Bet >= ( minimumAmountToRaiseTo-playersCurrentBet )*1.5 ) /* Need this scale factor? */
                {
                    /* Raise if confident that we have good cards */
                    if( Bet > playersRemainingChips )
                    {
                        /* Go all in if we dont have enough money to raise */
                        //System.out.println( "All in" );
                        return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                    }
                    //System.out.println( "Raise" );
                    return new BettingAnswer( BettingAnswer.ACTION_RAISE, Bet+playersCurrentBet );
                }
                else if( Bet >= ( maximumBet-playersCurrentBet ) )
                {
                    //System.out.println( "Call" );
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( BestHandValue > 0.7 && this.CurrentRound <= 3 )
                {
                    /* Too early to trust players aggresitivity, trust our own hand */
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }
                //System.out.println( "Fold" );
                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
            else if( Raised.LastAction == BettingAnswer.ACTION_ALLIN )
            {
                //System.out.println( "ALL IN BROUGHT US HERE" );
                if( playersRemainingChips >= ( maximumBet-playersCurrentBet ) )
                {
                    if( ( PlayStyle.CalcPlayStyle( Raised, this.CurrentRound ) > 0.5 ) )
                    {
                        /* This is an aggresive player */
                        if( BestHandValue > 0.6 )
                        {
                            //System.out.println( "Call" );
                            return new BettingAnswer( BettingAnswer.ACTION_CALL );
                        }
                    }
                }
                else
                {
                    if( ( PlayStyle.CalcPlayStyle( Raised, this.CurrentRound ) > 0.6 ) )
                    {
                        /* This is an aggresive player */
                        if( BestHandValue > 0.6 )
                        {
                            //System.out.println( "All in" );
                            return new BettingAnswer( BettingAnswer.ACTION_CALL );
                        }
                    }
                }
            }
            //System.out.println( "Fold NOOB" );
            return new BettingAnswer( BettingAnswer.ACTION_FOLD );
        }
    }

    /**
     * Called during the draw phase of the game when the player is offered to throw away some
     * (possibly all) of the cards on hand in exchange for new.
     * @return  An array of the cards on hand that should be thrown away in exchange for new,
     *          or <code>null</code> or an empty array to keep all cards.
     * @see     #infoCardsInHand(ca.ualberta.cs.poker.Hand)
     */
    protected Card[] queryCardsToThrow() {
        notifyTextReceivers("Requested information about what cards to throw");

        //System.out.println("CardsToThrow: " + CardsToThrow.length);
        CardsThrown = true;
        this.NoOfActions = 0;

        Card[] cards = new Card[CardsToThrow.length];
        for( int i = 0; i < CardsToThrow.length; i++ )
        {
            cards[i] = hand.getCard( CardsToThrow[i]+1 );
            //System.out.println( cards[ i ].getRank() + " " + cards[ i ].getSuit() );
        }

        Evaluated = false;

        return cards;
    }

    private void ThrowCalculator()
    {
        int[] TempHand = new int[5];
        int Card1 = 0, Card2 = 0, Card3 = 0, Card4 = 0, Card5 = 0;
        int[] CardsToThrowEval;
        CardsToThrow = new int[0];
        int Count = 0;
        double Value;
        //System.out.println( "**********************EVALUATING******************************" );

        BestHandValue = 1 - Ranker.rank( CardRepHand )/7462.0;

        /* Try to toss different combinations of card, a binary representation
         * of what cards to throw should make it!
         00010 means that card number 2 should be thrown*/
        for( int i = 1; i < 32; i++ )
        {
            System.arraycopy(CardRepHand, 0, TempHand, 0, 5);
            /* Replace cards we want to throw with 0 */
            Card1 = ( ( i & 0x1 ) == 0x1 ) ? 1 : 0;
            Card2 = ( ( i & 0x2 ) == 0x2 ) ? 1 : 0;
            Card3 = ( ( i & 0x4 ) == 0x4 ) ? 1 : 0;
            Card4 = ( ( i & 0x8 ) == 0x8 ) ? 1 : 0;
            Card5 = ( ( i & 0x10 ) == 0x10 ) ? 1 : 0;

            CardsToThrowEval = new int[ Card1 + Card2 + Card3 + Card4 + Card5 ];
            Count = 0;

            if( Card1 == 1 ) {
                CardsToThrowEval[ Count ] = 0;
                Count++;
            }
            if( Card2 == 1 ) {
                CardsToThrowEval[ Count ] = 1;
                Count++;
            }
            if( Card3 == 1 ) {
                CardsToThrowEval[ Count ] = 2;
                Count++;
            }
            if( Card4 == 1 ) {
                CardsToThrowEval[ Count ] = 3;
                Count++;
            }
            if( Card5 == 1 ) {
                CardsToThrowEval[ Count ] = 4;
            }
            
            Value = Evaluate( TempHand, CardsToThrowEval, 0, CardsToThrowEval.length-1 );
            Value /= Bionomial[ CardsToThrowEval.length-1 ];

            if( Value > BestHandValue )
            {
                CardsToThrow = new int[ Card1 + Card2 + Card3 + Card4 + Card5 ];
                System.arraycopy( CardsToThrowEval, 0, CardsToThrow, 0, CardsToThrowEval.length );
                BestHandValue = Value;
            }
        }
    }


    private double Evaluate( int[] TempHand, int[] CardsToThrow, int LoopCnt, int Depth )
    {
        double Value = 0;
        for( int i = LoopCnt; i < 52-Depth; i++ )
        {
            /* Increment i if card is unavailable */
            while( CardsLeft[ i ] == 0 )
            {
                i++;
                if( i == 52-Depth )
                {
                    return Value;
                }
            }

            TempHand[ CardsToThrow[ Depth ] ] = CardsLeft[ i ];
            
            if( Depth > 0 )
            {
                Value += Evaluate( TempHand, CardsToThrow, i+1, Depth-1 );
            }
            else
            {
                Value += ( 1 - Ranker.rank( TempHand )/7462.0 );
            }
        }
        return Value;
    }

    public double PositionScaling( int Position )
    {
        /* Returns a scaling value dependening the players position in the
         * betting round. Will return a value between 1 and 0.6.
         */
        double RetVal = ( 1-(Position-1)*0.4/Players.size() );
        if( RetVal < 0.6 || RetVal > 1 )
            return 0;
        return RetVal;
    }
}