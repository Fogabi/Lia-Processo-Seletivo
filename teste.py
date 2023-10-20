#Função search recebe dois parâmetros, courses e filters
def search(courses, filters):

    # Se não houver filtros, retorna todos os ids em efeito cascata, salvando cada id num array:

    if not filters:
        ids = []
        for course in courses.values(): 
            for levels in course.values():  
                for shifts in levels.values():
                    ids.append(shifts)
        return [item for sublist in ids for item in sublist]
    
    # Se houver filtros, há 3 possibilidades:

    if filters:
        for course in courses:
             # Primeiro verifica se o primeiro parâmetro curso corresponde ao item no JSON, isto é, se é o curso buscado.
            if(filters[0] in courses):

                #Se o parâmtro for único, ou seja, só foi indicado o curso e mais nenhum outro parâmtro, segue por aqui:

                if len(filters) == 1 :
                    shift = list(courses[filters[0]].values())
                    ids = [{'id': item['id']} for sublist in shift for lista in sublist.values() for item in lista]
                    return(ids)   
                
                # Se além do parâmetro curso, há também o nível, segue por aqui:

                new_courses = (courses[filters[0]]) # Uma nova lista de cursos para facilitar a manipulação do JSON
                level = new_courses[filters[1]] # Utilizado para pegar o parâmetro de nível para depois dar get nos ids corretos

                if len(filters) == 2:
                    if filters[1] in new_courses:
                        morning_ids = level.get('manha', [])
                        night_ids = level.get('noite', [])
                        ids = morning_ids + night_ids
                        return(ids)
                
                # Se tiver os 3 parâmetros, incluindo turno, segue por aqui:

                if len(filters) == 3:
                    if filters[1] in new_courses:
                        ids = level.get(filters[2], [])
                        return(ids)

#JSON de cursos
courses = {
    "espanhol": {
        "iniciante": {
            "manha": [{"id": 1}, {"id": 2}],
            "noite": [{"id": 3}, {"id": 4}]
        },
        "avancado": {
            "manha": [{"id": 5}, {"id": 6}]
        }
    },
    "ingles": {
        "avancado": {
            "manha": [{"id": 11}, {"id": 21}]
        }
    }
}

# Testes
print(search(courses, []))
print(search(courses, ['espanhol']))
print(search(courses, ['ingles', 'avancado']))
print(search(courses, ['espanhol', 'iniciante', 'manha']))
