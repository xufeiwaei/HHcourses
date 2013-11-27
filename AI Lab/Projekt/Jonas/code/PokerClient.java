/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.*;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Random;

/**
 * A class acting as a poker client. It extends the base class {@link PokerClientBase}
 * and is intended to be reviewed and/or changed by students.
 * @author Tobias Persson
 */


public class PokerClient extends PokerClientBase {
    private String name = "Compiler";
    private Random random = new Random( 2 );
    private Hand hand;

    private CardEvaluator ev;
    private Round PokerRound;
    private Hashtable Players;
    private int ActionsLastRaise;
    private int PlayersFolded;
    private int CurrentAnte;
    private String LastPlayerRised;
    
    /**
     * Creates a new instance of <code>PokerClient</code>.
     * @param server    the address of the poker server.
     * @param port      the port used by the poker server.
     */
    public PokerClient(String server, int port) {
        super(server, port);
        
        ev = new CardEvaluator();

        Players = new Hashtable();
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
            name = "Client#"+(System.currentTimeMillis() & 0xFFF);
        return name;
    }

    /**
     * Called when a new round begins.
     * @param round the round number (increased for each new round).
     */
    protected void infoNewRound(int round) {
        notifyTextReceivers("Starting round #"+round);

        System.out.println("\n*********************************************\n");

        PokerRound = new Round( round );

        ev.SetRound( PokerRound );

        PlayersFolded = 0;

        LastPlayerRised = "";
    }

    /**
     * Called when the poker server informs that the game is completed.
     */
    protected void infoGameOver() {
        notifyTextReceivers("The game is over.");
    }

    /**
     * Called when the server informs the players how many chips a player has.
     * @param playerName    the name of a player.
     * @param chips         the amount of chips the player has.
     */
    protected void infoPlayerChips(String playerName, int chips) {
        notifyTextReceivers("The player '"+playerName+"' has "+chips+" chips.");

        /*
         * If it is the start round then add the players to the list.
         */
        if( PokerRound.RoundNb == 1 )
        {
            Players.put(playerName, new Player( playerName, Players.size() ) );
        }
        if( (Player)Players.get( playerName ) != null )
        {
            /*
             * If player is in the list, check if the player got any chips left,
             * else the player is not in the game anymore.
             */
            if( chips == 0 )
            {
                Players.remove( playerName );
            }
            else
            {
                ( (Player)Players.get( playerName ) ).Chips = chips;
            }
        }
    }
    
    /**
     * Called when the ante has changed.
     * @param ante  the new value of the ante.
     */
    protected void infoAnteChanged(int ante) {
        notifyTextReceivers("The ante is "+ante);

        this.CurrentAnte = ante;
    }

    /**
     * Called when a player had to do a forced bet (putting the ante in the pot).
     * @param playerName    the name of the player forced to do the bet.
     * @param forcedBet     the number of chips forced to bet.
     */
    protected void infoForcedBet(String playerName, int forcedBet) {
        notifyTextReceivers("Player "+playerName +" made a forced bet of "+forcedBet + " chips.");

        /*
         * Player did a Forced Bet, still in the game then.
         */
        ((Player)Players.get( playerName )).InRound = true;
    }
    
    /**
     * Called when a player opens a betting round.
     * @param playerName        the name of the player that opens.
     * @param openBet           the amount of chips the player has put into the pot.
     */
    protected void infoPlayerOpen(String playerName, int openBet) {
        notifyTextReceivers("Player "+playerName +" opened, has put "+openBet+" chips into the pot.");

        ( (Player)Players.get( playerName ) ).Open++;
        ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_OPEN;
        LastPlayerRised = playerName;

        /*
         * New betting round starts with this opening raise. Reset number of
         * players that have answered this opening raise.
         */
        ActionsLastRaise = 1;
    }

    /**
     * Called when a player checks.
     * @param playerName        the name of the player that checks.
     */
    protected void infoPlayerCheck(String playerName) {
        notifyTextReceivers("Player "+playerName +" checked.");

        ( (Player)Players.get( playerName ) ).Check++;
        ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_CHECK;

        this.ActionsLastRaise++;
    }

    /**
     * Called when a player raises.
     * @param playerName        the name of the player that raises.
     * @param amountRaisedTo    the amount of chips the player raised to.
     */
    protected void infoPlayerRaise(String playerName, int amountRaisedTo) {
        notifyTextReceivers("Player "+playerName +" raised to "+amountRaisedTo+" chips.");

        ( (Player)Players.get( playerName ) ).Raise++;
        ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_RAISE;
        LastPlayerRised = playerName;

        /*
         * New betting round starts, reset number of players that have answered
         * this raise.
         */
        ActionsLastRaise = 1;
    }

    /**
     * Called when a player calls.
     * @param playerName        the name of the player that calls.
     */
    protected void infoPlayerCall(String playerName) {
        notifyTextReceivers("Player "+playerName +" called.");

        ( (Player)Players.get( playerName ) ).Call++;
        ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_CALL;

        this.ActionsLastRaise++;
    }

    /**
     * Called when a player folds.
     * @param playerName        the name of the player that folds.
     */
    protected void infoPlayerFold(String playerName) {
        notifyTextReceivers("Player "+playerName +" folded.");

        ( (Player)Players.get( playerName ) ).Fold++;
        ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_FOLD;

        PlayersFolded++;
        ((Player)Players.get( playerName )).InRound = false;
    }

    /**
     * Called when a player goes all-in.
     * @param playerName        the name of the player that goes all-in.
     * @param allInChipCount    the amount of chips the player has in the pot and goes all-in with.
     */
    protected void infoPlayerAllIn(String playerName, int allInChipCount) {
        notifyTextReceivers("Player "+playerName +" goes all-in with a pot of "+allInChipCount+" chips.");

        /*
         * Check if player is forced to go all in.
         */
        if( allInChipCount >= this.CurrentAnte )
        {
            ( (Player)Players.get( playerName ) ).Allin++;
            ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_ALLIN;
            this.ActionsLastRaise = 1;
            LastPlayerRised = playerName;
        }
        else
        {
            ( (Player)Players.get( playerName ) ).LastAction = BettingAnswer.ACTION_OPEN;
        }
    }

    /**
     * Called when a player has exchanged (thrown away and drawn new) cards.
     * @param playerName        the name of the player that has exchanged cards.
     * @param cardCount         the number of cards exchanged.
     */
    protected void infoPlayerDraw(String playerName, int cardCount) {
        notifyTextReceivers("Player "+playerName +" exchanged "+cardCount+" cards.");

        ( (Player)Players.get( playerName ) ).CardsThrown = cardCount;
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
    protected BettingAnswer queryOpenAction(int minimumPotAfterOpen, int playersCurrentBet, int playersRemainingChips)
    {
        notifyTextReceivers("Player requested to choose an opening action.");

        /*
         * Find out how many players left to answer OpenAction().
         */

        int PlayersLeftBettingRound = Players.size() - this.ActionsLastRaise - this.PlayersFolded;

        /*
         * Just a error check
         */
        if( PlayersLeftBettingRound < 0 )
            System.out.println("*-*-*-*-*-*-* Negative value of players left in betting round *-*-*-*-*-*-*\n");

        /*
         * Check chips left
         */
        if( ( minimumPotAfterOpen-playersCurrentBet ) > playersRemainingChips )
        {
            /*
             * Not enough chips to open the betting round. Choose All in or Check.
             */
            if( PokerRound.BestRank > 0.6 )
            {
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
            }

            return new BettingAnswer( BettingAnswer.ACTION_CHECK );           
        }
        else if( PokerRound.CardsThrown == false )
        {
            /*
             * Betting round before cards are thrown
             *
             * Calculate how much to bet and decide what action to do
             */

            int Bet = (int) ( StartBetValue( playersRemainingChips ) * PokerRound.BestRank * PokerRound.BestRank * PokerRound.BestRank * ScalePlayersLeft( PlayersLeftBettingRound ) );

            if( PokerRound.BestRank < 0.3 || Bet < 1 )
            {
                return new BettingAnswer( BettingAnswer.ACTION_CHECK );
            }

            if( Bet > playersRemainingChips )
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );

            return new BettingAnswer( BettingAnswer.ACTION_OPEN, Bet+playersCurrentBet );
        }
        else
        {
            int Bet = (int) ( StartBetValue( playersRemainingChips ) * PokerRound.BestRank * PokerRound.BestRank * PokerRound.BestRank * ScalePlayersLeft( PlayersLeftBettingRound ) );

            if( PokerRound.BestRank < 0.3 || Bet < 1 )
            {
                return new BettingAnswer( BettingAnswer.ACTION_CHECK );
            }

            if( Bet > playersRemainingChips )
                return new BettingAnswer( BettingAnswer.ACTION_ALLIN );

            return new BettingAnswer( BettingAnswer.ACTION_OPEN, Bet+playersCurrentBet );
        }
    }

    /**
     * Called when the player receives cards. The hand contains all cards the player currently holds.
     * @param hand  the hand of cards the player currently holds.
     */
    protected void infoCardsInHand(Hand hand)
    {
        notifyTextReceivers("The cards in hand is" + hand + ".");
        this.hand = hand;
        PokerRound.SetHand( this.hand );

        this.ActionsLastRaise = 0;


        if( PokerRound.CardsThrown )
        {
            ev.EvaluateStartHand();
        }
        else
        {
            //long l = System.currentTimeMillis();
            ev.EvaluateStartHand();
            ev.EvaluateHands();
            //System.out.println( "Time: "+(System.currentTimeMillis()-l) );
        }

        System.out.println("\n--------------New Hand------------------------\n");
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
    protected BettingAnswer queryCallRaiseAction(int maximumBet, int minimumAmountToRaiseTo, int playersCurrentBet, int playersRemainingChips )
    {
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

        /*
         * Evaluate your possibilites to get better cards if this is
         * the first time you bet
         */ 

        /*
         * Now decide how to bet
         */

        /*
         * Calculate how many players that have not answered on this betting round.
         * They will be asked how to do this after you.
         */

        int PlayersLeftBettingRound = Players.size() - this.ActionsLastRaise
                                      - this.PlayersFolded;
        int BetValue = 0;

        if( PlayersLeftBettingRound < 0 )
            System.out.println("*-*-*-*-*-*-* Negative value of players left in betting round *-*-*-*-*-*-*\n");

        /*
         * Get the playerstyle value for the player who raised/opened
         * current betting round.
         */

        Player p = ( Player )Players.get( this.LastPlayerRised );
        CalcPlayerStyle.CalcStyle( p, PokerRound.RoundNb );


        if( ( maximumBet-playersCurrentBet ) > playersRemainingChips )
        {
            /*
             * Not enough chips to call the raised bet. Choose All in or Fold.
             */
            if( PokerRound.CardsThrown )
            {
                if( p.CardsThrown >= 3  && PokerRound.BestRank >= 0.5 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                }
                if( p.CardsThrown == 2  && PokerRound.BestRank >= 0.75 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                }
                if( playersRemainingChips*2 <= playersCurrentBet )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                }
                    
                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
            else
            {
                if( p.PlayMode > 0.6 )
                {
                    if( PokerRound.BestRank > 0.4 )
                    {
                         return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                    }
                }
                if( playersRemainingChips*2 < playersCurrentBet )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                }
                
                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
        }
        else if( minimumAmountToRaiseTo-playersCurrentBet > playersRemainingChips )
        {
            /*
             * It's possible to call or fold but not Raise
             */

            if( p.LastAction == BettingAnswer.ACTION_OPEN )
            {
                /*
                 * This betting round started with Open
                 */
                BetValue =(int)( StartBetValue( playersRemainingChips )
                                 *ScalePlayersLeft( PlayersLeftBettingRound )
                                 *PokerRound.BestRank
                                 *CalcPlayerStyle.CalcOpenCheck( p, PokerRound.RoundNb ) );

                if( BetValue >= ( maximumBet-playersCurrentBet ) && PokerRound.BestRank > (( this.Players.size() == 2 )?0.3:0.4) )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( p.PlayMode > 0.6 && PokerRound.BestRank > 0.4 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( PokerRound.BestRank >= 0.6 && CalcPlayerStyle.CalcOpenCheck( p, PokerRound.RoundNb ) > 1 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
            else if( p.LastAction == BettingAnswer.ACTION_RAISE )
            {
                /*
                 * This betting round started with Raise
                 */
                BetValue =(int)( StartBetValue( playersRemainingChips )
                                 *ScalePlayersLeft( PlayersLeftBettingRound )
                                 *PokerRound.BestRank*CalcPlayerStyle.CalcRaiseCall( p, PokerRound.RoundNb ) );
                
                if( BetValue >= ( minimumAmountToRaiseTo-playersCurrentBet ) && PokerRound.BestRank > (( this.Players.size() == 2 )?0.3:0.4) )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( p.PlayMode > 0.6 && PokerRound.BestRank > 0.4 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( PokerRound.BestRank >= 0.6 && CalcPlayerStyle.CalcRaiseCall( p, PokerRound.RoundNb ) > 1 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
            else if( p.LastAction == BettingAnswer.ACTION_ALLIN )
            {
                if( playersRemainingChips > playersCurrentBet*2 && PokerRound.BestRank < 0.5 )
                    return new BettingAnswer( BettingAnswer.ACTION_FOLD );
                else if( p.PlayMode > 0.7 && PokerRound.BestRank > 0.55  )
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
            }
            return new BettingAnswer( BettingAnswer.ACTION_FOLD );
        }
        else
        {
            /*
             * It's possible to raise
             */

            if( p.LastAction == BettingAnswer.ACTION_OPEN )
            {
                /*
                 * This betting round started with Open
                 */
                BetValue =(int)( StartBetValue( playersRemainingChips )
                                 *ScalePlayersLeft( PlayersLeftBettingRound )
                                 *PokerRound.BestRank*PokerRound.BestRank
                                 *CalcPlayerStyle.CalcOpenCheck( p, PokerRound.RoundNb ) );

                if( BetValue >= ( minimumAmountToRaiseTo-playersCurrentBet ) && PokerRound.BestRank > (( this.Players.size() == 2 )?0.3:0.45) )
                {
                    if( BetValue > playersRemainingChips )
                    {
                        if( playersRemainingChips > playersCurrentBet*2 )
                            return new BettingAnswer( BettingAnswer.ACTION_FOLD );
                        else
                            return new BettingAnswer( BettingAnswer.ACTION_ALLIN );
                    }
                    
                    return new BettingAnswer( BettingAnswer.ACTION_RAISE, BetValue+playersCurrentBet);
                }
                else if( BetValue >= ( maximumBet - playersCurrentBet ) && PokerRound.BestRank > (( this.Players.size() == 2 )?0.3:0.4) )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( PokerRound.BestRank > 0.7 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                return new BettingAnswer( BettingAnswer.ACTION_FOLD );

            }
            else if( p.LastAction == BettingAnswer.ACTION_RAISE )
            {
                /*
                 * This betting round started with Raise
                 */
                BetValue =(int)( StartBetValue( playersRemainingChips )
                                 *PokerRound.BestRank*CalcPlayerStyle.CalcRaiseCall( p, PokerRound.RoundNb ) );

                if( BetValue >= ( minimumAmountToRaiseTo-playersCurrentBet ) && PokerRound.BestRank > (( this.Players.size() == 2 )?0.3:0.45) )
                {
                    if( BetValue > playersRemainingChips )
                    {
                        if( playersRemainingChips > playersCurrentBet*2 )
                            return new BettingAnswer( BettingAnswer.ACTION_FOLD );
                        else
                            return new BettingAnswer( BettingAnswer.ACTION_ALLIN );                        
                    }
                    
                    return new BettingAnswer( BettingAnswer.ACTION_RAISE, BetValue+playersCurrentBet);
                }
                else if( BetValue >= ( maximumBet - playersCurrentBet ) && PokerRound.BestRank > (( this.Players.size() == 2 )?0.3:0.4) )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                if( PokerRound.BestRank > 0.7 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }

                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
            else if( p.LastAction == BettingAnswer.ACTION_ALLIN )
            {
                if( p.PlayMode > 0.6 && PokerRound.BestRank > 0.4 )
                {
                    return new BettingAnswer( BettingAnswer.ACTION_CALL );
                }
                return new BettingAnswer( BettingAnswer.ACTION_FOLD );
            }
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

        Card[] Cards;

        this.ActionsLastRaise = 0;

        if( PokerRound.CardsToThrow == null )
        {
            System.out.println("-------->Throw 0 cards!<--------");
            Cards = new Card[ 0 ];
            return Cards;
        }
        
        Cards = new Card[ PokerRound.CardsToThrow.length ];
        for( int i = 0; i < Cards.length; ++i )
        {
            System.out.println("-------->Throw card: Suit: "+hand.getCard( PokerRound.CardsToThrow[ i ]+1 ).getSuit()+", rank: "+hand.getCard( PokerRound.CardsToThrow[ i ]+1 ).getRank()+"<--------");
            Cards[i] = hand.getCard( PokerRound.CardsToThrow[ i ]+1 ); // getCard uses one-based indexing, not zero-based.
        }
        PokerRound.CardsThrown = true;
        return Cards;
    }

    public double ScalePlayersLeft( int PlayersLeft )
    {
        return 1-( PlayersLeft-1 )*0.4/this.Players.size();
    }

    public int StartBetValue(int ChipsLeft)
    {
        double Product = 1;
        if( this.Players.size() == 2)
        {
            Product = 2;
        }
        if( ChipsLeft < 100 )
        {
            return 100;
        }
        else if( ChipsLeft < 800 )
        {
            return (int)(200*Product);
        }
        else
        {
            return (int)(300*Product);
        }
    }
}
