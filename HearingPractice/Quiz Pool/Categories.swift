// FoodItems.swift
import Foundation

enum Category: String, CaseIterable {
    case initialConsonants = "Initial Consonants"
    case medialVowels = "Medial Vowels"
    case finalConsonants = "Final Consonants"
    case food = "Food"
    case animals = "Animals"
    case disney = "Disney"
    case colors = "Colors & Shapes"
    case actions = "Action Words"
    case places = "Places"
    case everyday = "Everyday Objects"
    case nature = "Nature & Weather"
    case phrases = "Phrases"
    // Add more categories here
}
let foodItems: [String] = [
    "Apple", "Banana", "Orange", "Grapes", "Pineapple", "Strawberry", "Blueberry", "Raspberry", "Mango", "Peach", "Pear", "Watermelon", "Cantaloupe", "Honeydew", "Lemon", "Lime", "Cherry", "Plum", "Apricot", "Kiwi", "Blackberry", "Fig", "Date", "Papaya", "Guava", "Lychee", "Passionfruit", "Pomegranate", "Cranberry", "Mulberry", "Coconut", "Avocado", "Tomato", "Cucumber", "Bell Pepper", "Carrot", "Broccoli", "Cauliflower", "Spinach", "Lettuce", "Kale", "Swiss Chard", "Arugula", "Zucchini", "Eggplant", "Mushroom", "Onion", "Garlic", "Potato", "Sweet Potato", "Yam", "Beetroot", "Turnip", "Radish", "Peas", "Green Beans", "Asparagus", "Artichoke", "Brussel Sprouts", "Cabbage", "Celery", "Leek", "Fennel", "Okra", "Pumpkin", "Squash", "Corn", "Chili Pepper", "Jalapeño", "Habanero", "Serrano", "Poblano", "Tomato Sauce", "Ketchup", "Mayonnaise", "Mustard", "Soy Sauce", "Teriyaki Sauce", "BBQ Sauce", "Hot Sauce", "Salad Dressing", "Ranch Dressing", "Caesar Dressing", "Italian Dressing", "French Dressing", "Thousand Island Dressing", "Blue Cheese Dressing", "Vinaigrette", "Olive Oil", "Coconut Oil", "Butter", "Margarine", "Cheese", "Mozzarella", "Cheddar", "Swiss", "Gouda", "Parmesan", "Brie", "Camembert", "Feta", "Goat Cheese", "Blue Cheese", "Ricotta", "Cottage Cheese", "Cream Cheese", "Yogurt", "Milk", "Almond Milk", "Soy Milk", "Oat Milk", "Rice Milk", "Ice Cream", "Gelato", "Sorbet", "Frozen Yogurt", "Pudding", "Custard", "Whipped Cream", "Chocolate", "Dark Chocolate", "White Chocolate", "Milk Chocolate", "Candy", "Lollipop", "Gummy Bears", "Jelly Beans", "Marshmallow", "Caramel", "Toffee", "Fudge", "Peanut Butter", "Nutella", "Honey", "Maple Syrup", "Pancakes", "Waffles", "French Toast", "Cereal", "Granola", "Oatmeal", "Porridge", "Bread", "Whole Wheat Bread", "White Bread", "Sourdough", "Baguette", "Croissant", "Bagel", "Muffin", "Scone", "Biscuit", "Crackers", "Tortilla", "Pita Bread", "Naan", "Rice", "Brown Rice", "White Rice", "Basmati Rice", "Jasmine Rice", "Quinoa", "Couscous", "Barley", "Bulgur", "Pasta", "Spaghetti", "Fettuccine", "Penne", "Macaroni", "Ravioli", "Lasagna", "Gnocchi", "Dumplings", "Pizza", "Burger", "Hot Dog", "Sandwich", "Wrap", "Taco", "Burrito", "Quesadilla", "Nachos", "Fries", "Onion Rings", "Chicken Wings", "Chicken Nuggets", "Fried Chicken", "Grilled Chicken", "Roast Chicken", "Beef", "Steak", "Ribs", "Lamb", "Pork", "Bacon", "Ham", "Sausage", "Meatballs", "Fish", "Salmon", "Tuna", "Cod", "Haddock", "Mackerel", "Sardines", "Shrimp", "Crab", "Lobster", "Mussels", "Clams", "Oysters", "Scallops", "Squid", "Octopus", "Sushi", "Sashimi", "Tempura", "Ramen", "Pho", "Spring Rolls", "Egg Rolls", "Dim Sum", "Dumplings", "Pad Thai", "Fried Rice", "Stir Fry", "Curry", "Tofu", "Seitan", "Tempeh", "Falafel", "Hummus", "Guacamole", "Salsa", "Chutney", "Kimchi", "Sauerkraut", "Pickles", "Olives", "Capers", "Sun-Dried Tomatoes", "Artichoke Hearts", "Spinach Dip", "Queso Dip", "French Onion Dip", "Buffalo Chicken Dip", "Nacho Cheese Dip", "Pesto", "Alfredo Sauce", "Marinara Sauce", "Bolognese Sauce", "Carbonara Sauce", "Puttanesca Sauce", "Tzatziki Sauce", "Aioli", "Tahini", "Miso", "Wasabi", "Ginger", "Garlic Bread", "Bruschetta", "Crostini", "Pita Chips", "Bagel Chips", "Pretzels", "Popcorn", "Potato Chips", "Tortilla Chips", "Kale Chips", "Vegetable Chips", "Fruit Snacks", "Trail Mix", "Nuts", "Almonds", "Walnuts", "Cashews", "Peanuts", "Pistachios", "Pecans", "Macadamia Nuts", "Hazelnuts", "Seeds", "Sunflower Seeds", "Pumpkin Seeds", "Chia Seeds", "Flax Seeds", "Sesame Seeds", "Hemp Seeds", "Protein Bars", "Granola Bars", "Energy Bars", "Smoothies", "Juices", "Lemonade", "Iced Tea", "Hot Chocolate", "Coffee", "Espresso", "Cappuccino", "Latte", "Macchiato", "Mocha", "Americano", "Tea", "Green Tea", "Black Tea", "Herbal Tea", "Chai Tea", "Matcha", "Milkshake", "Smoothie Bowl", "Acai Bowl", "Fruit Salad", "Vegetable Salad", "Caesar Salad", "Greek Salad", "Caprese Salad", "Cobb Salad", "Chef Salad", "Chicken Salad", "Tuna Salad", "Egg Salad", "Potato Salad", "Pasta Salad", "Quinoa Salad", "Bean Salad", "Lentil Salad", "Rice Salad", "Tabbouleh", "Coleslaw", "Waldorf Salad", "Broccoli Salad", "Spinach Salad", "Kale Salad", "Avocado Salad", "Beet Salad", "Carrot Salad", "Cucumber Salad", "Tomato Salad", "Corn Salad", "Mango Salad", "Papaya Salad", "Watermelon Salad", "Strawberry Salad", "Blueberry Salad", "Raspberry Salad", "Fruit Tart", "Apple Pie", "Pumpkin Pie", "Pecan Pie", "Cherry Pie", "Blueberry Pie", "Lemon Meringue Pie", "Key Lime Pie", "Chocolate Cake", "Vanilla Cake", "Red Velvet Cake", "Carrot Cake", "Cheesecake", "Cupcakes", "Brownies", "Blondies", "Cookies", "Chocolate Chip Cookies", "Oatmeal Raisin Cookies", "Peanut Butter Cookies", "Sugar Cookies", "Gingerbread Cookies", "Biscotti", "Macarons", "Eclairs", "Profiteroles", "Cannoli", "Tiramisu", "Panna Cotta", "Creme Brulee", "Flan", "Churros", "Doughnuts", "Cinnamon Rolls", "Pastries", "Danish", "Croissants", "Strudel", "Scones", "Muffins", "Bagels", "Bread Pudding", "Rice Pudding", "Tapioca Pudding", "Custard", "Trifle", "Pavlova", "Souffle", "Ice Cream Sundae", "Milkshake", "Smoothie", "Fruit Juice", "Lemonade", "Limeade", "Iced Coffee", "Hot Chocolate", "Herbal Tea", "Green Juice", "Protein Shake", "Energy Drink", "Soda", "Sparkling Water", "Mineral Water", "Sports Drink", "Beer", "Wine", "Champagne", "Whiskey", "Vodka", "Rum", "Tequila", "Gin", "Brandy", "Sangria", "Cocktails", "Margarita"
]

let phrases = [
            QuizQuestion(options: ["The cat is sleeping", "The dog is barking", "The bird is flying", "The fish is swimming", "The rabbit is hopping", "The turtle is crawling"]),
            QuizQuestion(options: ["I like apples", "I like bananas", "I like grapes", "I like oranges", "I like peaches", "I like strawberries"]),
            QuizQuestion(options: ["The car is fast", "The bike is slow", "The train is on time", "The plane is delayed", "The boat is ready", "The bus is coming"]),
            QuizQuestion(options: ["She is reading a book", "He is writing a letter", "They are watching TV", "We are playing a game", "I am doing homework", "You are drawing pictures"]),
            QuizQuestion(options: ["The sun is shining", "The moon is bright", "The stars are twinkling", "The clouds are fluffy", "The sky is clear", "The night is dark"]),
            QuizQuestion(options: ["The flowers are blooming", "The trees are tall", "The grass is green", "The leaves are falling", "The bushes are growing", "The plants are healthy"]),
            QuizQuestion(options: ["The pizza is hot", "The ice cream is cold", "The soup is warm", "The salad is fresh", "The sandwich is tasty", "The cookie is sweet"]),
            QuizQuestion(options: ["The music is loud", "The movie is interesting", "The book is thrilling", "The game is fun", "The show is exciting", "The story is amazing"]),
            QuizQuestion(options: ["The house is big", "The apartment is cozy", "The garden is beautiful", "The kitchen is clean", "The bedroom is neat", "The bathroom is tidy"]),
            QuizQuestion(options: ["The ocean is deep", "The river is flowing", "The lake is calm", "The waterfall is loud", "The pond is still", "The stream is clear"]),
            QuizQuestion(options: ["The teacher is kind", "The student is attentive", "The class is quiet", "The lesson is important", "The homework is ready", "The test is tomorrow"]),
            QuizQuestion(options: ["The city is busy", "The village is peaceful", "The town is growing", "The neighborhood is friendly", "The street is crowded", "The park is empty"]),
            QuizQuestion(options: ["The shop is open", "The market is crowded", "The mall is huge", "The store is closed", "The bakery is busy", "The cafe is quiet"]),
            QuizQuestion(options: ["The computer is new", "The phone is old", "The tablet is fast", "The laptop is slow", "The keyboard is clean", "The mouse is working"]),
            QuizQuestion(options: ["The cat is purring", "The dog is running", "The bird is chirping", "The fish is jumping", "The hamster is spinning", "The rabbit is eating"]),
            QuizQuestion(options: ["The clock is ticking", "The alarm is ringing", "The bell is chiming", "The watch is beeping", "The timer is counting", "The buzzer is sounding"]),
            QuizQuestion(options: ["The doctor is helping", "The nurse is caring", "The patient is resting", "The hospital is busy", "The clinic is open", "The medicine is working"]),
            QuizQuestion(options: ["The sun is setting", "The moon is rising", "The stars are shining", "The night is calm", "The dawn is breaking", "The sky is glowing"]),
            QuizQuestion(options: ["The child is laughing", "The baby is crying", "The parent is smiling", "The family is happy", "The toddler is playing", "The sister is singing"]),
            QuizQuestion(options: ["The cake is sweet", "The chocolate is rich", "The candy is colorful", "The cookie is delicious", "The brownie is chewy", "The cupcake is pretty"]),
            QuizQuestion(options: ["The bus is late", "The train is early", "The taxi is waiting", "The bike is parked", "The car is moving", "The truck is loading"]),
            QuizQuestion(options: ["The beach is sandy", "The mountain is high", "The forest is dense", "The desert is dry", "The valley is green", "The cliff is steep"]),
            QuizQuestion(options: ["The athlete is strong", "The team is winning", "The coach is guiding", "The game is exciting", "The player is skilled", "The crowd is cheering"]),
            QuizQuestion(options: ["The chair is comfortable", "The table is sturdy", "The sofa is soft", "The bed is cozy", "The cushion is fluffy", "The pillow is plump"]),
            QuizQuestion(options: ["The pasta is tasty", "The rice is fluffy", "The bread is fresh", "The cheese is melted", "The sauce is savory", "The noodles are hot"]),
            
            // Daily Activities
            QuizQuestion(options: ["I wake up early", "I go to bed late", "I eat breakfast now", "I take a shower first", "I get dressed quickly", "I brush my teeth"]),
            QuizQuestion(options: ["He brushes his teeth", "She combs her hair", "They wash their hands", "We clean our room", "I make my bed", "You pack your bag"]),
            QuizQuestion(options: ["I am getting dressed", "You are packing lunch", "He is tying shoes", "She is putting on coat", "We are leaving soon", "They are ready now"]),
            QuizQuestion(options: ["The door is open", "The window is closed", "The light is on", "The fan is off", "The curtain is drawn", "The blinds are up"]),
            QuizQuestion(options: ["I need help please", "Can you come here", "Will you wait for me", "May I go now", "Could you show me", "Should I start"]),
            
            // School & Learning
            QuizQuestion(options: ["I study every day", "You read the book", "He does homework", "She takes notes", "We practice writing", "They learn math"]),
            QuizQuestion(options: ["The answer is correct", "The question is hard", "The test is easy", "The grade is good", "The quiz is short", "The exam is long"]),
            QuizQuestion(options: ["I raise my hand", "You listen carefully", "He asks a question", "She gives an answer", "We pay attention", "They work together"]),
            QuizQuestion(options: ["We learn new things", "They practice math", "I write a story", "You draw a picture", "He solves problems", "She reads aloud"]),
            QuizQuestion(options: ["The pencil is sharp", "The eraser is pink", "The paper is white", "The crayon is blue", "The marker is red", "The pen is black"]),
            
            // Food & Eating
            QuizQuestion(options: ["I am hungry now", "You are thirsty too", "He wants lunch", "She needs water", "We want snacks", "They need dinner"]),
            QuizQuestion(options: ["The apple is red", "The banana is yellow", "The grape is purple", "The orange is round", "The lemon is sour", "The strawberry is sweet"]),
            QuizQuestion(options: ["Breakfast is ready", "Lunch is served", "Dinner is cooking", "Snack is waiting", "Dessert is coming", "Food is hot"]),
            QuizQuestion(options: ["I like pizza best", "You prefer pasta", "He loves burgers", "She enjoys salad", "We want tacos", "They choose soup"]),
            QuizQuestion(options: ["The milk is cold", "The coffee is hot", "The juice is sweet", "The water is fresh", "The tea is warm", "The soda is fizzy"]),
            
            // Weather & Seasons
            QuizQuestion(options: ["It is raining outside", "It is snowing today", "It is sunny now", "It is windy here", "It is cloudy there", "It is foggy morning"]),
            QuizQuestion(options: ["Spring brings flowers", "Summer is hot", "Fall has leaves", "Winter is cold", "Autumn is colorful", "Spring is rainy"]),
            QuizQuestion(options: ["The sky is blue", "The clouds are white", "The rainbow is colorful", "The sunset is beautiful", "The sunrise is bright", "The stars are pretty"]),
            QuizQuestion(options: ["I wear a jacket", "You need an umbrella", "He has mittens", "She brings boots", "We grab coats", "They carry hats"]),
            QuizQuestion(options: ["It is very warm", "It is quite cool", "It is too hot", "It is really cold", "It is super nice", "It is pretty mild"]),
            
            // Family & Friends
            QuizQuestion(options: ["My mom is nice", "My dad is tall", "My sister is young", "My brother is funny", "My cousin is smart", "My friend is kind"]),
            QuizQuestion(options: ["I love my family", "You have good friends", "He helps others", "She cares a lot", "We support each other", "They stay together"]),
            QuizQuestion(options: ["We play together", "They laugh a lot", "I share my toys", "You tell stories", "He builds blocks", "She sings songs"]),
            QuizQuestion(options: ["Grandma visits us", "Grandpa tells jokes", "Aunt brings gifts", "Uncle plays games", "Cousin comes over", "Nephew runs around"]),
            QuizQuestion(options: ["The baby is cute", "The toddler is active", "The kid is smart", "The teen is helpful", "The child is happy", "The infant is small"]),
            
            // Feelings & Emotions
            QuizQuestion(options: ["I feel happy today", "You look sad now", "He seems angry", "She appears worried", "We are excited", "They feel calm"]),
            QuizQuestion(options: ["I am excited", "You are nervous", "He is proud", "She is grateful", "We are cheerful", "They are pleased"]),
            QuizQuestion(options: ["That makes me smile", "This makes you laugh", "It makes him think", "That makes her wonder", "This makes us happy", "It makes them giggle"]),
            QuizQuestion(options: ["I am tired now", "You are wide awake", "He is sleepy", "She is energetic", "We are rested", "They are alert"]),
            QuizQuestion(options: ["I feel better now", "You seem fine", "He looks great", "She appears well", "We are healthy", "They feel good"]),
            
            // Colors & Descriptions
            QuizQuestion(options: ["My favorite is blue", "Your choice is red", "His pick is green", "Her color is pink", "Our choice is yellow", "Their favorite is purple"]),
            QuizQuestion(options: ["The ball is round", "The box is square", "The star is pointy", "The heart is curved", "The circle is perfect", "The triangle is sharp"]),
            QuizQuestion(options: ["This is very big", "That is quite small", "It is really tall", "They are so tiny", "These are huge", "Those are little"]),
            QuizQuestion(options: ["The room is bright", "The hallway is dark", "The space is wide", "The path is narrow", "The area is open", "The corner is dim"]),
            QuizQuestion(options: ["It feels soft", "It looks hard", "It seems rough", "It appears smooth", "It is bumpy", "It is silky"]),
            
            // Time & Schedule
            QuizQuestion(options: ["It is morning time", "It is noon already", "It is evening now", "It is night soon", "It is afternoon later", "It is midnight past"]),
            QuizQuestion(options: ["Today is Monday", "Tomorrow is Tuesday", "Yesterday was Sunday", "The day is Friday", "Next is Wednesday", "Last was Thursday"]),
            QuizQuestion(options: ["I am early today", "You are on time", "He is running late", "She arrived first", "We came early", "They were delayed"]),
            QuizQuestion(options: ["We meet at three", "They come at four", "I leave at five", "You return at six", "He arrives at seven", "She departs at eight"]),
            QuizQuestion(options: ["The show starts soon", "The class begins now", "The game ends later", "The event finishes early", "The movie plays next", "The concert opens tonight"]),
            
            // Actions & Movement
            QuizQuestion(options: ["I can run fast", "You can jump high", "He can swim well", "She can dance beautifully", "We can skip quickly", "They can hop far"]),
            QuizQuestion(options: ["We walk to school", "They ride the bus", "I take the train", "You drive the car", "He bikes to work", "She skates to park"]),
            QuizQuestion(options: ["He climbs the tree", "She crosses the street", "I go up stairs", "You come down hill", "We walk over bridge", "They run through field"]),
            QuizQuestion(options: ["Let's go outside", "Let's stay inside", "Let's move forward", "Let's step back", "Let's turn around", "Let's walk ahead"]),
            QuizQuestion(options: ["I stand up tall", "You sit down here", "He lies down there", "She kneels on floor", "We bend over low", "They crouch down now"]),
            
            // Places & Locations
            QuizQuestion(options: ["I live in town", "You stay in city", "He works in office", "She studies in library", "We meet in school", "They play in gym"]),
            QuizQuestion(options: ["We meet at park", "They play at playground", "I shop at store", "You eat at restaurant", "He waits at station", "She reads at library"]),
            QuizQuestion(options: ["The book is here", "The pen is there", "The bag is nearby", "The coat is far", "The toy is close", "The ball is away"]),
            QuizQuestion(options: ["Go to the left", "Turn to the right", "Look straight ahead", "Step to the side", "Move to center", "Walk to corner"]),
            QuizQuestion(options: ["It is upstairs", "It is downstairs", "It is outside", "It is inside", "It is nearby", "It is far away"]),
            
            // Animals & Pets
            QuizQuestion(options: ["I have a dog", "You own a cat", "He keeps fish", "She has hamsters", "We raise chickens", "They feed rabbits"]),
            QuizQuestion(options: ["The puppy is playful", "The kitten is soft", "The bunny is fluffy", "The bird is colorful", "The hamster is tiny", "The guinea pig is cute"]),
            QuizQuestion(options: ["Dogs like to bark", "Cats like to purr", "Birds like to sing", "Fish like to swim", "Rabbits like to hop", "Hamsters like to run"]),
            QuizQuestion(options: ["My pet is friendly", "Your pet is quiet", "His pet is active", "Her pet is gentle", "Our pet is playful", "Their pet is calm"]),
            QuizQuestion(options: ["The horse is fast", "The turtle is slow", "The rabbit is quick", "The snail is tiny", "The cheetah is speedy", "The sloth is lazy"]),
            
            // Activities & Hobbies
            QuizQuestion(options: ["I like to read", "You love to draw", "He enjoys sports", "She prefers music", "We practice dance", "They watch movies"]),
            QuizQuestion(options: ["We play soccer", "They play basketball", "I play tennis", "You play baseball", "He plays hockey", "She plays volleyball"]),
            QuizQuestion(options: ["I collect stamps", "You build models", "He paints pictures", "She makes crafts", "We create art", "They design posters"]),
            QuizQuestion(options: ["Reading is fun", "Writing is creative", "Drawing is relaxing", "Singing is joyful", "Dancing is exciting", "Playing is enjoyable"]),
            QuizQuestion(options: ["I practice piano", "You play guitar", "He learns drums", "She studies violin", "We try flute", "They practice trumpet"]),
            
            // Numbers & Counting
            QuizQuestion(options: ["I have one apple", "You have two oranges", "He has three bananas", "She has four grapes", "We have five pears", "They have six peaches"]),
            QuizQuestion(options: ["There are five birds", "There are six dogs", "There are seven cats", "There are eight fish", "There are nine frogs", "There are ten bees"]),
            QuizQuestion(options: ["I count to ten", "You add the numbers", "He solves the problem", "She finds the answer", "We multiply values", "They subtract totals"]),
            QuizQuestion(options: ["This costs five dollars", "That is ten cents", "It needs twenty coins", "They want fifty bills", "We have thirty pennies", "You need forty quarters"]),
            QuizQuestion(options: ["The first one wins", "The second place gets prize", "The third runner finishes", "The last person waits", "The fourth place tries", "The middle one rests"]),
            
            // Health & Body
            QuizQuestion(options: ["I feel sick today", "You look healthy", "He seems fine", "She feels great", "We are well", "They appear strong"]),
            QuizQuestion(options: ["My head hurts", "Your arm is sore", "His leg is tired", "Her back is strong", "Our feet ache", "Their hands are clean"]),
            QuizQuestion(options: ["I wash my face", "You brush your hair", "He clips his nails", "She cleans her ears", "We dry our hands", "They comb their hair"]),
            QuizQuestion(options: ["Exercise is good", "Sleep is important", "Water is healthy", "Vegetables are nutritious", "Fruit is delicious", "Walking is helpful"]),
            QuizQuestion(options: ["I take medicine", "You rest in bed", "He drinks soup", "She feels better", "We eat well", "They stay warm"]),
            
            // Technology & Devices
            QuizQuestion(options: ["I use the computer", "You check the phone", "He watches the tablet", "She types on keyboard", "We browse online", "They play games"]),
            QuizQuestion(options: ["The screen is bright", "The battery is low", "The volume is high", "The signal is weak", "The connection is strong", "The power is off"]),
            QuizQuestion(options: ["Turn it on now", "Turn it off please", "Charge it up", "Plug it in", "Switch it over", "Power it down"]),
            QuizQuestion(options: ["I send a message", "You make a call", "He takes a picture", "She records a video", "We share photos", "They watch clips"]),
            QuizQuestion(options: ["The app is fun", "The game is hard", "The video is long", "The song is short", "The movie is good", "The show is new"])
        ]

let animalItems: [String] = [
    "Aardvark", "Albatross", "Alligator", "Alpaca", "Anaconda", "Ant", "Anteater", "Antelope", "Ape", "Armadillo", "Baboon", "Badger", "Bandicoot", "Barnacle", "Barracuda", "Bat", "Bear", "Beaver", "Bee", "Beetle", "Bison", "Blackbird", "Boa", "Bobcat", "Bonito", "Bonobo", "Booby", "Bovid", "Budgerigar", "Buffalo", "Butterfly", "Buzzard", "Camel", "Capybara", "Caracal", "Caribou", "Carp", "Cat", "Caterpillar", "Catfish", "Centipede", "Chameleon", "Chamois", "Cheetah", "Chicken", "Chimpanzee", "Chinchilla", "Chipmunk", "Cicada", "Clam", "Clownfish", "Cobra", "Cockroach", "Cod", "Condor", "Constrictor", "Coral", "Cougar", "Cow", "Coyote", "Crab", "Crane", "Crayfish", "Cricket", "Crocodile", "Crow", "Cuckoo", "Cuttlefish", "Deer", "Dingo", "Dodo", "Dog", "Dolphin", "Donkey", "Dormouse", "Dove", "Dragonfly", "Duck", "Dugong", "Dunlin", "Eagle", "Earthworm", "Echidna", "Eel", "Egret", "Elephant", "Elk", "Emu", "Falcon", "Ferret", "Finch", "Firefly", "Fish", "Flamingo", "Flea", "Fly", "Fox", "Frog", "Gannet", "Gazelle", "Gecko", "Gerbil", "Giraffe", "Gnat", "Gnu", "Goat", "Goldfish", "Goose", "Gorilla", "Grasshopper", "Grouse", "Guanaco", "Gull", "Hamster", "Hare", "Hawk", "Hedgehog", "Heron", "Herring", "Hippopotamus", "Hornet", "Horse", "Human", "Hummingbird", "Hyena", "Ibis", "Iguana", "Impala", "Jackal", "Jaguar", "Jellyfish", "Kangaroo", "Kingfisher", "Koala", "Kodiak", "Kookaburra", "Kouprey", "Krill", "Ladybird", "Lamprey", "Landfowl", "Lark", "Lemur", "Leopard", "Lion", "Lizard", "Llama", "Lobster", "Locust", "Loon", "Loris", "Lynx", "Macaw", "Magpie", "Mallard", "Manatee", "Mandrill", "Manta Ray", "Marmoset", "Marmot", "Meerkat", "Mink", "Mole", "Mongoose", "Monkey", "Moose", "Mosquito", "Moth", "Mouse", "Mule", "Narwhal", "Newt", "Nightingale", "Nighthawk", "Numbat", "Ocelot", "Octopus", "Okapi", "Opossum", "Orangutan", "Orca", "Ostrich", "Otter", "Owl", "Ox", "Oyster", "Panther", "Parrot", "Peacock", "Pelican", "Penguin", "Perch", "Pheasant", "Pig", "Pigeon", "Pike", "Piranha", "Platypus", "Polar Bear", "Pony", "Porcupine", "Porpoise", "Possum", "Prawn", "Puffin", "Puma", "Quail", "Rabbit", "Raccoon", "Ram", "Rat", "Raven", "Reindeer", "Rhino", "Rook", "Rooster", "Salamander", "Salmon", "Sand Dollar", "Sardine", "Scorpion", "Seahorse", "Seal", "Serval", "Shark", "Sheep", "Shrew", "Shrimp", "Skunk", "Sloth", "Snail", "Snake", "Sparrow", "Spider", "Squid", "Squirrel", "Starfish", "Stork", "Swan", "Tapir", "Tarantula", "Tarsier", "Termite", "Tiger", "Toad", "Toucan", "Trout", "Tuna", "Turkey", "Turtle", "Viper", "Vulture", "Wallaby", "Walrus", "Wasp", "Weasel", "Whale", "Wildcat", "Wildebeest", "Wolf", "Wolverine", "Wombat", "Woodpecker", "Worm", "Wren", "Yak", "Zebra", "Zebu", "Zonkey", "Zorse", "Tamarin", "Tapir", "Thrush", "Tilapia", "Titmouse", "Tortoise", "Vicuna", "Vole", "Wapiti", "Warbler", "Waxwing", "Wagtail", "Tern", "Tamarin", "Takin", "Tarantula", "Terrapin", "Tetrapod", "Thylacine", "Tiglon", "Trogon", "Troodontid", "Trumpeter", "Tropicbird", "Tuatara", "Turaco", "Uakari", "Uguisu", "Uinta Chipmunk", "Umbrellabird"
]

let disneyItems: [String] = [
    "Mickey Mouse",
    "Minnie Mouse",
    "Donald Duck",
    "Daisy Duck",
    "Goofy",
    "Pluto",
    "Cinderella",
    "Snow White",
    "Ariel",
    "Belle",
    "Jasmine",
    "Pocahontas",
    "Mulan",
    "Rapunzel",
    "Tiana",
    "Elsa",
    "Anna",
    "Moana",
    "Simba",
    "Nala",
    "Timon",
    "Pumbaa",
    "Mufasa",
    "Scar",
    "Aladdin",
    "Genie",
    "Abu",
    "Jafar",
    "Peter Pan",
    "Tinker Bell",
    "Wendy Darling",
    "Captain Hook",
    "Alice",
    "Mad Hatter",
    "Cheshire Cat",
    "Queen of Hearts",
    "Winnie the Pooh",
    "Piglet",
    "Tigger",
    "Eeyore",
    "Christopher Robin",
    "Dumbo",
    "Bambi",
    "Thumper",
    "Flower",
    "Pinocchio",
    "Jiminy Cricket",
    "Peter Pan",
    "Captain Hook",
    "Lady",
    "Tramp",
    "Baloo",
    "Bagheera",
    "Mowgli",
    "Shere Khan",
    "King Louie",
    "Hercules",
    "Megara",
    "Hades",
    "Tarzan",
    "Jane Porter",
    "Buzz Lightyear",
    "Woody",
    "Jessie",
    "Rex",
    "Mr Potato Head",
    "Hamm",
    "Bo Peep",
    "Slinky Dog",
    "Mike Wazowski",
    "Sully",
    "Boo",
    "Nemo",
    "Dory",
    "Marlin",
    "Bruce",
    "Elastigirl",
    "Mr Incredible",
    "Violet Parr",
    "Dash Parr",
    "Jack Jack Parr",
    "Edna Mode",
    "Carl Fredricksen",
    "Russell",
    "Dug",
    "WALL E",
    "EVE",
    "Lightning McQueen",
    "Mater",
    "Remy",
    "Linguini",
    "Emile",
    "Carl Fredricksen",
    "Russell",
    "Dug",
    "Joy",
    "Sadness",
    "Anger",
    "Disgust",
    "Fear",
    "Asha",
    "Hank", "Merida", "Queen Elinor",
    "King Fergus", "Angus", "Stitch", "Lilo", "Nani", "Jumba", "Pleakley",
    "Tadashi Hamada", "Hiro Hamada", "Baymax", "Honey Lemon", "Go Go Tomago",
    "Wasabi", "Fred", "Tiana", "Prince Naveen", "Dr. Facilier", "Ray", "Louis",
    "Charlotte LaBouff", "Mama Odie", "Eudora", "King Triton", "Sebastian",
    "Flounder", "Scuttle", "Prince Eric", "Grimsby", "Max", "Ursula", "Flotsam",
    "Jetsam", "Lady Tremaine", "Drizella", "Anastasia", "Fairy Godmother",
    "Gus Gus", "Jaq", "Cinderella's Prince", "Sleeping Beauty", "Aurora",
    "Prince Phillip", "Maleficent", "Flora", "Fauna", "Merryweather", "Merlin",
    "Arthur", "Maid Marian", "Robin Hood", "Little John", "Friar Tuck", "Prince John",
    "Sheriff of Nottingham", "Lady Kluck", "Roger Radcliffe", "Anita Radcliffe",
    "Pongo", "Perdita", "Cruella de Vil", "Patch", "Rolly", "Lucky",
    "Sven", "Kristoff", "Hans", "Oaken", "Olaf"
]
// Similar sounds organized by consonant groups
let bSounds: [String] = [
    "Back", "Bad", "Bag", "Ball", "Bank", "Bat", "Bath", "Bay", "Bear", "Beat",
    "Bed", "Bell", "Belt", "Best", "Bet", "Big", "Bike", "Bill", "Bird", "Black"
]

let cSounds: [String] = [
    "Call", "Calm", "Camp", "Can", "Cap", "Car", "Card", "Care", "Case", "Cash",
    "Cat", "Catch", "Cause", "Cell", "Chair", "Cheap", "Check", "Chest", "Child", "Chip"
]

let dSounds: [String] = [
    "Dad", "Daily", "Dance", "Dark", "Date", "Day", "Deal", "Dear", "Death", "Deep",
    "Desk", "Diet", "Dig", "Dime", "Dirt", "Dish", "Do", "Dog", "Door", "Dot"
]

let fSounds: [String] = [
    "Face", "Fact", "Fail", "Fair", "Fall", "False", "Fame", "Fan", "Far", "Farm",
    "Fast", "Fat", "Fear", "Feed", "Feel", "Feet", "Fell", "Felt", "Few", "Field"
]

let pSounds: [String] = [
    "Pack", "Pad", "Page", "Pain", "Paint", "Pair", "Palm", "Pan", "Park", "Part",
    "Pass", "Past", "Path", "Pay", "Peace", "Peak", "Pen", "Pet", "Phone", "Pick"
]

// All initial consonant groups combined
let initialConsonantsGroups: [[String]] = [bSounds, cSounds, dSounds, fSounds, pSounds]
// Flattened list for backward compatibility
let initialConsonantsItems: [String] = initialConsonantsGroups.flatMap { $0 }

// MARK: - Medial Vowels (middle vowel sounds)

let aVowels: [String] = [
    "Back", "Bat", "Cap", "Cat", "Dad", "Fan", "Gap", "Hat", "Jack", "Lap",
    "Map", "Nap", "Pack", "Ran", "Sad", "Tap", "Van", "Wax", "Yak", "Zap"
]
let eVowels: [String] = [
    "Bed", "Beg", "Bet", "Deck", "Den", "Fed", "Get", "Hen", "Jet", "Ken",
    "Led", "Let", "Met", "Net", "Peg", "Red", "Set", "Ten", "Vet", "Web"
]

let iVowels: [String] = [
    "Bid", "Big", "Bit", "Dig", "Dim", "Fin", "Fit", "Hid", "Hip", "Kit",
    "Lid", "Lip", "Mit", "Pin", "Pit", "Rib", "Sit", "Tip", "Win", "Zip"
]

let oVowels: [String] = [
    "Bob", "Box", "Cot", "Dock", "Dog", "Fox", "Got", "Hop", "Hot", "Job",
    "Knot", "Lot", "Mop", "Not", "Pot", "Rock", "Sock", "Top", "Tot", "Wok"
]

let uVowels: [String] = [
    "Bud", "Bug", "Bun", "Bus", "Cub", "Cup", "Cut", "Dug", "Fun", "Gum",
    "Gun", "Hug", "Hut", "Jug", "Mud", "Nut", "Pup", "Run", "Sun", "Tub"
]

// All medial vowel groups combined
let medialVowelsGroups: [[String]] = [aVowels, eVowels, iVowels, oVowels, uVowels]
let medialVowelsItems: [String] = medialVowelsGroups.flatMap { $0 }

// MARK: - Final Consonants (ending consonant sounds)

let tEndings: [String] = [
    "Bat", "Bet", "Bit", "Boot", "Boat", "But", "Cat", "Cut", "Dot", "Eat",
    "Fat", "Feet", "Flat", "Get", "Hat", "Heat", "Hit", "Hurt", "Knit", "Lot"
]

let pEndings: [String] = [
    "Cap", "Chop", "Clap", "Cup", "Deep", "Dip", "Drop", "Gap", "Grip", "Heap",
    "Help", "Hip", "Hop", "Jump", "Keep", "Lap", "Lip", "Map", "Mop", "Nap"
]
let kEndings: [String] = [
    "Back", "Bake", "Bike", "Book", "Break", "Check", "Click", "Cook", "Dark", "Deck",
    "Disk", "Duck", "Fake", "Fork", "Hack", "Hook", "Kick", "Lake", "Lock", "Make"
]

let dEndings: [String] = [
    "Bad", "Bed", "Bid", "Blood", "Bread", "Build", "Card", "Cold", "Dead", "End",
    "Feed", "Find", "Food", "Good", "Had", "Head", "Kind", "Lend", "Load", "Mad"
]

let nEndings: [String] = [
    "Ban", "Bean", "Bin", "Born", "Brain", "Brown", "Burn", "Can", "Chain", "Clean",
    "Coin", "Den", "Down", "Fan", "Fin", "Green", "Gun", "Man", "Mean", "Pan"
]

// All final consonant groups combined
let finalConsonantsGroups: [[String]] = [tEndings, pEndings, kEndings, dEndings, nEndings]
let finalConsonantsItems: [String] = finalConsonantsGroups.flatMap { $0 }

// MARK: - Colors & Shapes (200 words)

let colorsAndShapes: [String] = [
    // Colors
    "Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Pink", "Brown", "Black", "White",
    "Gray", "Tan", "Gold", "Silver", "Beige", "Navy", "Teal", "Maroon", "Lime", "Mint",
    "Peach", "Cream", "Ivory", "Rust", "Salmon", "Coral", "Magenta", "Violet", "Indigo", "Turquoise",
    "Crimson", "Scarlet", "Ruby", "Rose", "Cherry", "Wine", "Plum", "Lavender", "Lilac", "Mauve",
    "Sky Blue", "Baby Blue", "Royal Blue", "Cobalt", "Sapphire", "Ocean", "Sea Green", "Forest Green",
    "Olive", "Jade", "Emerald", "Lime Green", "Neon", "Lemon", "Mustard", "Amber", "Bronze", "Copper",
    "Chocolate", "Coffee", "Mocha", "Sand", "Khaki", "Charcoal", "Slate", "Pearl", "Snow", "Ash",
    
    // Shapes
    "Circle", "Square", "Triangle", "Rectangle", "Oval", "Diamond", "Heart", "Star", "Cube", "Sphere",
    "Cone", "Cylinder", "Pyramid", "Hexagon", "Pentagon", "Octagon", "Crescent", "Arrow", "Cross", "Plus",
    "Ring", "Arc", "Line", "Curve", "Spiral", "Zigzag", "Wave", "Dot", "Point", "Edge",
    
    // Size & Appearance Words
    "Big", "Small", "Tiny", "Huge", "Large", "Little", "Short", "Tall", "Long", "Wide",
    "Narrow", "Thick", "Thin", "Fat", "Skinny", "Round", "Flat", "Smooth", "Rough", "Bumpy",
    "Soft", "Hard", "Sharp", "Dull", "Bright", "Dark", "Light", "Heavy", "Shiny", "Glossy",
    "Matte", "Clear", "Cloudy", "Solid", "Hollow", "Full", "Empty", "Deep", "Shallow", "High",
    "Low", "Steep", "Gentle", "Curved", "Straight", "Bent", "Twisted", "Crooked", "Level", "Slanted",
    "Spotted", "Striped", "Checked", "Plain", "Fancy", "Simple", "Complex", "Neat", "Messy", "Clean",
    "Dirty", "New", "Old", "Fresh", "Stale", "Wet", "Dry", "Hot", "Cold", "Warm",
    "Cool", "Frozen", "Melted", "Solid", "Liquid", "Fuzzy", "Fluffy", "Silky", "Furry", "Hairy",
    "Bald", "Wrinkled", "Crinkled", "Folded", "Stretched", "Loose", "Tight", "Baggy", "Fitted", "Snug",
    "Colorful", "Dull", "Vivid", "Pale", "Faded", "Bold", "Pastel", "Neon", "Metallic", "Sparkly"
]
// MARK: - Action Words (200 words)

let actionWords: [String] = [
    "Run", "Walk", "Jump", "Hop", "Skip", "Dance", "Spin", "Turn", "Twist", "Bend",
    "Stretch", "Reach", "Grab", "Hold", "Catch", "Throw", "Toss", "Roll", "Bounce", "Kick",
    "Hit", "Push", "Pull", "Lift", "Carry", "Drop", "Fall", "Trip", "Slip", "Slide",
    "Climb", "Crawl", "Creep", "March", "Stomp", "Tiptoe", "Shuffle", "Waddle", "Strut", "Stumble",
    "Look", "See", "Watch", "Stare", "Peek", "Glance", "Wink", "Blink", "Squint", "Gaze",
    "Listen", "Hear", "Talk", "Speak", "Say", "Tell", "Shout", "Yell", "Scream", "Whisper",
    "Sing", "Hum", "Chant", "Call", "Ask", "Answer", "Reply", "Laugh", "Giggle", "Chuckle",
    "Smile", "Grin", "Frown", "Cry", "Sob", "Weep", "Sigh", "Gasp", "Groan", "Moan",
    "Eat", "Drink", "Chew", "Swallow", "Bite", "Lick", "Taste", "Sip", "Gulp", "Munch",
    "Nibble", "Slurp", "Cook", "Bake", "Fry", "Boil", "Mix", "Stir", "Pour", "Spill",
    "Sleep", "Wake", "Rest", "Nap", "Snore", "Dream", "Yawn", "Doze", "Snooze", "Toss",
    "Read", "Write", "Draw", "Paint", "Color", "Sketch", "Trace", "Erase", "Cut", "Paste",
    "Fold", "Tear", "Rip", "Crumple", "Smooth", "Press", "Stamp", "Print", "Copy", "Type",
    "Think", "Know", "Learn", "Study", "Teach", "Remember", "Forget", "Wonder", "Imagine", "Pretend",
    "Play", "Work", "Help", "Share", "Give", "Take", "Get", "Find", "Lose", "Search",
    "Hide", "Seek", "Show", "Point", "Wave", "Clap", "Snap", "Tap", "Pat", "Rub",
    "Scratch", "Tickle", "Hug", "Kiss", "Touch", "Feel", "Pinch", "Poke", "Squeeze", "Press",
    "Open", "Close", "Shut", "Lock", "Unlock", "Start", "Stop", "Begin", "End", "Finish",
    "Go", "Come", "Leave", "Stay", "Move", "Stand", "Sit", "Lie", "Kneel", "Squat",
    "Wait", "Hurry", "Rush", "Race", "Chase", "Follow", "Lead", "Guide", "Drive", "Ride"
]

// MARK: - Places (200 words)

let places: [String] = [
    // Buildings
    "House", "Home", "Apartment", "Condo", "Cabin", "Cottage", "Mansion", "Castle", "Palace", "Tower",
    "School", "Classroom", "Library", "Gym", "Cafeteria", "Office", "Store", "Shop", "Mall", "Market",
    "Bank", "Post Office", "Hospital", "Clinic", "Pharmacy", "Restaurant", "Cafe", "Diner", "Bakery", "Kitchen",
    "Church", "Temple", "Mosque", "Museum", "Gallery", "Theater", "Cinema", "Stadium", "Arena", "Park",
    "Zoo", "Aquarium", "Farm", "Barn", "Stable", "Garage", "Shed", "Workshop", "Factory", "Warehouse",
    
    // Rooms
    "Bedroom", "Bathroom", "Living Room", "Dining Room", "Kitchen", "Basement", "Attic", "Closet", "Hallway", "Garage",
    "Lobby", "Foyer", "Den", "Study", "Playroom", "Laundry Room", "Pantry", "Nursery", "Guest Room", "Sunroom",
    
    // Outdoor Places
    "Yard", "Garden", "Field", "Meadow", "Forest", "Woods", "Jungle", "Desert", "Beach", "Shore",
    "Coast", "Island", "Mountain", "Hill", "Valley", "Canyon", "Cave", "Cliff", "Rock", "Boulder",
    "Lake", "Pond", "River", "Stream", "Creek", "Brook", "Ocean", "Sea", "Bay", "Harbor",
    "Swamp", "Marsh", "Wetland", "Prairie", "Plain", "Plateau", "Peak", "Summit", "Ridge", "Slope",
    
    // Community Places
    "Town", "City", "Village", "Neighborhood", "Street", "Road", "Avenue", "Lane", "Alley", "Path",
    "Sidewalk", "Corner", "Block", "Square", "Plaza", "Courtyard", "Parking Lot", "Driveway", "Highway", "Bridge",
    "Tunnel", "Station", "Airport", "Dock", "Port", "Marina", "Terminal", "Platform", "Gate", "Entrance",
    
    // Countries & Regions
    "America", "Canada", "Mexico", "England", "France", "Spain", "Italy", "Germany", "China", "Japan",
    "India", "Brazil", "Africa", "Asia", "Europe", "North Pole", "South Pole", "Equator", "Tropics", "Arctic",
    
    // General Locations
    "North", "South", "East", "West", "Left", "Right", "Up", "Down", "Front", "Back",
    "Top", "Bottom", "Middle", "Center", "Side", "Inside", "Outside", "Above", "Below", "Near",
    "Far", "Close", "Here", "There", "Everywhere", "Nowhere", "Somewhere", "Anywhere", "Upstairs", "Downstairs",
    "Underground", "Underwater", "Overhead", "Ground", "Floor", "Ceiling", "Wall", "Door", "Window", "Roof",
    "Porch", "Deck", "Balcony", "Terrace", "Stairs", "Steps", "Ladder", "Ramp", "Elevator", "Escalator"
]

// MARK: - Everyday Objects (200 words)

let everydayObjects: [String] = [
    // Clothing
    "Shirt", "Pants", "Dress", "Skirt", "Shorts", "Jeans", "Sweater", "Jacket", "Coat", "Shoes",
    "Socks", "Hat", "Cap", "Gloves", "Mittens", "Scarf", "Belt", "Tie", "Underwear", "Pajamas",
    "Robe", "Slippers", "Boots", "Sandals", "Sneakers", "Vest", "Hoodie", "T-shirt", "Blouse", "Uniform",
    
    // School Supplies
    "Pencil", "Pen", "Eraser", "Crayon", "Marker", "Paper", "Notebook", "Folder", "Binder", "Backpack",
    "Ruler", "Scissors", "Glue", "Tape", "Stapler", "Calculator", "Book", "Textbook", "Dictionary", "Map",
    "Globe", "Chalk", "Whiteboard", "Desk", "Chair", "Table", "Lamp", "Computer", "Tablet", "Phone",
    
    // Kitchen Items
    "Plate", "Bowl", "Cup", "Glass", "Mug", "Fork", "Spoon", "Knife", "Chopsticks", "Napkin",
    "Pot", "Pan", "Lid", "Oven", "Stove", "Fridge", "Freezer", "Microwave", "Toaster", "Blender",
    "Mixer", "Kettle", "Pitcher", "Bottle", "Can", "Jar", "Container", "Lunch Box", "Thermos", "Tray",
    
    // Furniture
    "Bed", "Mattress", "Pillow", "Blanket", "Sheet", "Quilt", "Comforter", "Sofa", "Couch", "Armchair",
    "Dresser", "Cabinet", "Shelf", "Bookcase", "Mirror", "Rug", "Carpet", "Curtain", "Blinds", "Clock",
    
    // Bathroom Items
    "Towel", "Soap", "Shampoo", "Toothbrush", "Toothpaste", "Comb", "Brush", "Mirror", "Sink", "Toilet",
    "Shower", "Bathtub", "Faucet", "Drain", "Tissue", "Toilet Paper", "Bath Mat", "Scale", "Lotion", "Razor",
    
    // Toys & Games
    "Ball", "Doll", "Toy", "Puzzle", "Game", "Card", "Board Game", "Video Game", "Blocks", "Legos",
    "Action Figure", "Stuffed Animal", "Teddy Bear", "Bike", "Scooter", "Skateboard", "Jump Rope", "Kite", "Yo-Yo", "Marbles",
    
    // Electronics
    "TV", "Remote", "Radio", "Speaker", "Headphones", "Earbuds", "Camera", "Video", "Mouse", "Keyboard",
    "Monitor", "Screen", "Charger", "Cable", "Plug", "Battery", "Flashlight", "Watch", "Alarm", "Timer",
    
    // Tools & Hardware
    "Hammer", "Nail", "Screw", "Screwdriver", "Wrench", "Pliers", "Saw", "Drill", "Tool", "Toolbox",
    "Ladder", "Rope", "Chain", "Lock", "Key", "Handle", "Knob", "Switch", "Button", "Lever",
    
    // Miscellaneous
    "Bag", "Box", "Basket", "Bucket", "Trash Can", "Recycling Bin", "Vase", "Frame", "Picture", "Photo",
    "Candle", "Matches", "Lighter", "Fan", "Heater", "Air Conditioner", "Vacuum", "Broom", "Mop", "Sponge",
    "Dish", "Dust Pan", "Hanger", "Iron", "Ironing Board", "Laundry Basket", "Washing Machine", "Dryer", "Detergent", "Bleach"
]

// MARK: - Nature & Weather (200 words)

let natureAndWeather: [String] = [
    // Weather
    "Sun", "Sunny", "Sunshine", "Rain", "Rainy", "Snow", "Snowy", "Wind", "Windy", "Cloud",
    "Cloudy", "Storm", "Stormy", "Thunder", "Lightning", "Hail", "Sleet", "Fog", "Foggy", "Mist",
    "Misty", "Drizzle", "Shower", "Rainbow", "Tornado", "Hurricane", "Blizzard", "Frost", "Freeze", "Ice",
    "Icy", "Hot", "Cold", "Warm", "Cool", "Humid", "Dry", "Wet", "Breeze", "Gust",
    
    // Sky & Space
    "Sky", "Moon", "Star", "Planet", "Comet", "Meteor", "Galaxy", "Constellation", "Sunrise", "Sunset",
    "Dawn", "Dusk", "Twilight", "Noon", "Midnight", "Day", "Night", "Morning", "Evening", "Afternoon",
    
    // Plants
    "Tree", "Branch", "Twig", "Trunk", "Root", "Bark", "Leaf", "Leaves", "Bush", "Shrub",
    "Flower", "Petal", "Stem", "Seed", "Bud", "Bloom", "Blossom", "Rose", "Daisy", "Tulip",
    "Sunflower", "Lily", "Orchid", "Vine", "Ivy", "Moss", "Fern", "Grass", "Weed", "Clover",
    "Plant", "Cactus", "Palm", "Pine", "Oak", "Maple", "Birch", "Willow", "Cedar", "Redwood",
    
    // Landscape Features
    "Land", "Ground", "Soil", "Dirt", "Mud", "Sand", "Gravel", "Pebble", "Stone", "Rock",
    "Mountain", "Hill", "Valley", "Canyon", "Cliff", "Cave", "Volcano", "Crater", "Peak", "Summit",
    "Ridge", "Slope", "Plateau", "Plain", "Field", "Meadow", "Prairie", "Desert", "Oasis", "Dune",
    
    // Water Features
    "Water", "Ocean", "Sea", "Lake", "Pond", "River", "Stream", "Creek", "Brook", "Waterfall",
    "Rapids", "Current", "Wave", "Tide", "Ripple", "Splash", "Puddle", "Pool", "Spring", "Well",
    "Swamp", "Marsh", "Wetland", "Shore", "Beach", "Coast", "Island", "Peninsula", "Bay", "Gulf",
    
    // Insects & Small Creatures
    "Bee", "Butterfly", "Moth", "Ant", "Spider", "Fly", "Mosquito", "Beetle", "Ladybug", "Dragonfly",
    "Grasshopper", "Cricket", "Caterpillar", "Worm", "Snail", "Slug", "Firefly", "Wasp", "Hornet", "Flea",
    
    // Seasons & Times
    "Spring", "Summer", "Fall", "Autumn", "Winter", "Season", "Month", "Week", "Year", "Decade",
    "January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
    "November", "December", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Weekend",
    
    // Natural Elements
    "Fire", "Flame", "Smoke", "Ash", "Ember", "Spark", "Air", "Oxygen", "Breeze", "Gale",
    "Earth", "Nature", "Environment", "Ecosystem", "Habitat", "Wilderness", "Countryside", "Landscape", "Scenery", "View"
]


