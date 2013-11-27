/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

/**
 *
 * @author Jonas
 */
public class CalcPlayerStyle {

    public static double Fold = 0;
    public static double Check = 0.2;
    public static double Call = 0.5;
    public static double Open = 0.6;
    public static double Raise = 0.8;
    public static double Allin = 1;

    public static double Default = 0.3;

    public static void CalcStyle( Player p, int Round )
    {
        int Accuracy = 1;

        if( Round <= 4 )
        {
            Accuracy = Round/4;
        }
        
        p.PlayMode = ( ( p.Allin*Allin + p.Call*Call + p.Check*Check + p.Fold*Fold
                         + p.Open*Open + p.Raise*Raise ) /
                       ( p.Allin+p.Call+p.Check+p.Fold+p.Open+p.Raise ) ) * Accuracy;
    }

    public static double CalcRaiseCall( Player p, int Round )
    {
        double Accuracy = 1;

        if( Round <= 4 )
        {
            Accuracy = Round/4.0;
        }

        return ( p.Raise * 1.0 )/( p.Call+p.Raise )*Accuracy+0.5;
    }

    public static double CalcOpenCheck( Player p, int Round )
    {
        double Accuracy = 1;

        if( Round <= 4 )
        {
            Accuracy = Round/4.0;
        }

        return ( p.Open * 1.0 )/( p.Check + p.Open )*Accuracy+0.5;
    }
}
