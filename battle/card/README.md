# Card
In the card folder you'll find all scripts and scenes related to cards.

### Creating new cards
To create a new card, follow these steps:
	1. Add the new card enum to battle/card/CardDatabase.cards
	2. Add card information to battle/card/CardDatabase.card_info
	3. Create new .gd entry in battle/card/library
	4. Update battle/card/get_card_class()

### Card images
For now, all card imagery is AI generated (https://app.leonardo.ai/image-generation). Create either
a png or jpg file (TODO: pick one and make them all the same) and store it locally in 
battle/card/library/{FACTION}/images. Also upload it to the google docs folder

### Testing the card
To test if the card is working correctly, you can add it to the PLAYER_TESTING and OPPONENT_TESTING
decks in battle/player/DeckCollection.gd. You will be able to play the cards for free when you hit
"Testing Game" in the main menu
