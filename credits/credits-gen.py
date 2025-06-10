from dataclasses import dataclass
import csv
import re

# sorted alphabetically (excl admin at the end)
teams = [
    "Art",
    "Design",
    "Programming",
    "Sound",
    "Admin",
]

# TODO: 
# team agnostic categories: 
# Character Design (Art, Design or Sound)

# sorted by team then alphabetically
category_to_team = {
    "Character Design (art)": "Art",
    "Character Artist": "Art",
    "Environmental Artist": "Art",
    "Food Artist": "Art",
    "UI (art)": "Art",

    "Character Design (design)": "Design",
    "Cooking (design)": "Design",
    "Dates System (design)": "Design",
    "Narrative Designer & Scriptwriter (design)": "Design",
    "QA Tester": "Design",
    "Relationship System (design)": "Design",
    "UX Design (design)": "Design",

    "Cooking (programming)": "Programming",
    "Free roam (programming)": "Programming",
    "UI (programming)": "Programming",

    "Character Design (sound)": "Sound",
    "Music (sound)": "Sound",
    "SFX (sound)": "Sound",
    "Voice Acting (sound)": "Sound",
}

team_to_categories: dict[str, list[str]] = {
    "Admin": []
}
for category, team in category_to_team.items():
    if team not in team_to_categories:
        team_to_categories[team] = list()
    team_to_categories[team].append(category)

regex = r',\s*(?![^()]*\))'

@dataclass
class Person:
    name: str
    categories: list[str]
    team: str
    character_name: str | None

people: list[Person] = []

with open('gdignored/credits.csv', newline='') as csvfile:
    reader = csv.reader(csvfile)
    i = iter(reader)
    _ = next(i) # skip first line

    for row in i:
        name = row[1]
        categories = re.split(regex, row[3])
        character_name = row[5]
        if character_name in ["", "N/A"]: character_name = None

        people.append(Person(name, categories, category_to_team[categories[0]], character_name))
people.sort(key = lambda p: p.name)

@dataclass
class ProloguePerson:
    name: str
    role: str

# little over-engineered but ¯\_(ツ)_/¯
prologue_people = {
        "Art": [
            ProloguePerson("Jonah Kassoy", "Art Director"),
            ProloguePerson("Joan Palacios", "Assistant Art Director"),
        ],
        "Design": [
            ProloguePerson("Brenden Choi", "Design Director"),
            ProloguePerson("Andrew McGaffic", "Assistant Design Director"),
            ProloguePerson("Ethan Hayes", "Assistant Design Director"),
        ],
        "Programming": [
            ProloguePerson("Michael Campbell", "Programming Co-director"),
            ProloguePerson("Justin Langdon", "Programming Co-director"),
        ],
        "Sound": [
            ProloguePerson("Miles Tison", "Sound Co-director"),
            ProloguePerson("Daniel Irchai", "Sound Co-director"),
        ],
        "Admin": [
            ProloguePerson("Matthew Neri", "Co-president"),
            ProloguePerson("Khalid Moosa", "Co-president & Social Media Manager"),
            ProloguePerson("Maia Ocampo", "Vice President"),
            ProloguePerson("Alex James", "Production Manager"),
            ProloguePerson("John McGuire", "Secretary"),
            ProloguePerson("Zachary Kim", "Treasurer"),
            ProloguePerson("Evan Kusko", "Web Master"),
        ],
}

epilogues = {
    "Sound": "Thank you to GMU Voice Acting Club!"
}

TEAM_FONT_SIZE = 75
CATEGORY_FONT_SIZE = 50
EPILOGUE_FONT_SIZE = 35
CHARACTER_NAME_FONT_SIZE = 32

for team in teams:
    print(f"[font_size={TEAM_FONT_SIZE}][wave amp=50.0 freq=4.0 connected=0]{team}[/wave][/font_size]")

    for person in prologue_people[team]:
        print(f"\t{person.role} {person.name}")

    print()
    for category in team_to_categories[team]:
        display_category = re.sub(r"\([^)]*\)", "", category)
        print(f"\t[font_size={CATEGORY_FONT_SIZE}][wave amp=35.0 freq=4.0 connected=0]{display_category}[/wave][/font_size]")
        for person in [p for p in people if category in p.categories]:
            if person.character_name != None and category == "Voice Acting (sound)":
                print(f"\t\t[i][font_size={CHARACTER_NAME_FONT_SIZE}]{person.character_name}[/font_size][/i]:    {person.name}")
            else:
                print(f"\t\t{person.name}")

        print()

    if team in epilogues:
        print(f"\t[center][font_size={EPILOGUE_FONT_SIZE}][wave amp=35.0 freq=4.0 connected=0]{epilogues[team]}[/wave][/font_size][/center]")
    print()

