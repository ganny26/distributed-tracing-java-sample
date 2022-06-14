import random
result = "afsidjfienrknsal;fnjsdilfnwifnewinriweroerfw1e65g03w54er35e13r541ewrewrewrfnjsdilfnwifnewinriweroerfw1e65g03w54er35e13r541ewrewrewrfnjsdilfnw"
l = list(result)
with open("/tmp/in.txt", "w") as f:
    for i in range(30000):
        random.shuffle(l)
        result = ''.join(l)
        f.write(result)
