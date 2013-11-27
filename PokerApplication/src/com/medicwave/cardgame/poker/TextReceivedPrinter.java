/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

/**
 * A class that prints all text received on the standard output.
 * @author Tobias Persson
 */
public class TextReceivedPrinter implements ITextReceiver {

    /**
     * Prints all text received on the standard output, preceeded by the string
     * representation of the sender.
     * @param sender    the source of the message.
     * @param text      the message text.
     */
    public void textReceived(Object sender, String messageText) {
        System.out.println(sender.toString() + ": " + messageText);
    }

}
