def tag(input: str):
    return "\\${" + input + "}"

def pass_resolvers():
    return {"tag": tag} 