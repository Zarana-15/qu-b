from os import environ
import os
from flask import Flask, request
from passlib.hash import sha256_crypt
import re
import pymongo
import jwt
from bson.json_util import dumps
from flask_cors import CORS, cross_origin
import json as Json

from bson import ObjectId

#nlp 
#import numpy as np
#import pandas as pd
import nltk 
import gensim
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from nltk.tokenize import word_tokenize
from gensim.models import Word2Vec
import spacy
from spacy.lang.en import English


emailreg = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'

jwtSecret = 'hdjskvndjsknvkd65fd4v15f6dvdbhdbv2545d4v6dcdbhjbjbdv554163223*#((#4545dsfdscscscs'

app = Flask(__name__)

CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'
cors = CORS(app, resources={r"/punishments": {"origins": "*"}})

connection = pymongo.MongoClient(
    "mongodb+srv://Qu-B:Qu-B123@cluster0.wsxia.mongodb.net/myFirstDatabase?retryWrites=true&w=majority&ssl=true&ssl_cert_reqs=CERT_NONE")
database = connection['DQBMS']
collections = ['Users', 'MCQ', 'MCA', 'Theory', 'T/F', 'FIB']
col = database[collections[0]]


@app.route('/Login', methods=['POST'])
def Login():
    error = None
    if request.method == 'POST':
        json = request.json
        col = database[collections[0]]
        res = col.find_one({"email": json['email'].strip()})
        if res is not None:
            if(sha256_crypt.verify(str(json['password']).strip(), str(res['password']))):
                payload = {
                    "_id": str(res['_id']),
                    "name": res['name'],
                    "email": res['email']
                }
                token = jwt.encode(payload=payload, key=jwtSecret,algorithm="HS256")
                return {'Message': 'Login Successful', 'token': token}, 200
            else:
                return {'Message': 'Invalid Email or Password'}, 401
        else:
            return {'Message': 'Invalid Email or Password'}, 401

@app.route('/EditProfile', methods=['POST'])
def EditProfile():
    if request.method == 'POST':
        json = request.json
        try:
            token = jwt.decode(json['token'], key=jwtSecret, algorithms=["HS256"])

            if(re.fullmatch(emailreg, str(json['email']).strip()) == None):
                return {'Message': 'Invalid Email'}, 400

            col = database[collections[0]]
            if(col.find_one({"email": json['email'].strip()}) is not None):
                return {'Message': 'Email already exists'}, 409
            col = database[collections[0]]
            res = col.update_one({"_id":ObjectId(token['_id'])},{"$set": {
                "name": json['name'],
                "email": json["email"],
                "phone": json['phone']
            }})
            if res.modified_count>0:
                    payload = {
                    "_id": str(token['_id']),
                    "name": str(json['name']).strip(),
                    "email": str(json["email"]).strip()
                    }
                    tk = jwt.encode(payload=payload, key=jwtSecret,algorithm="HS256")
                    return {'Message': 'Update Successful','token':tk}, 200
            else:
                return {'Message': 'Update Unsuccessful, Please Try Again!'}, 401
        except Exception as e:
            #print(e)
            return {'Message': 'Invalid Token'}, 401


@app.route('/Register', methods=['POST'])
def Register():
    if request.method == 'POST':
        json = request.json

        if(re.fullmatch(emailreg, json['email']) == None):
            return {'Message': 'Invalid Email'}, 400

        col = database[collections[0]]
        if(col.find_one({"email": json['email'].strip()}) is not None):
            return {'Message': 'Email already exists'}, 409

        if len(json['password']) < 5:
            return {'Message': 'Password length less than 5'}, 400

        hashedpass = sha256_crypt.hash(str(json['password']).strip())

        data = {
            'name': json['name'].strip(),
            'email': json['email'].strip(),
            'password': hashedpass,
            'phone': json['phone'].strip()
        }
        res = col.insert_one(data)
        if res.acknowledged:
            return {'Message': 'User Created'}, 201
        else:
            return {'Message': 'User Not Created'}, 409


@app.route('/Search', methods=['POST'])
def Search():
    if request.method == 'POST':
        json = request.json
        try:
            jwt.decode(json['token'], key=jwtSecret, algorithms=["HS256"])
            col = database[json['Type']]
            searchopt = json['searchby']
            
            if(searchopt['Subject']!=[] and searchopt['Marks']!= '' and searchopt['Bloom’s Taxonomy']!=[] and searchopt['Keywords']!=[]):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Marks': searchopt['Marks']}, {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}},{'Tags.Keywords': {"$all": searchopt['Keywords']}}]})
            
            elif(searchopt['Subject']!=[] and searchopt['Marks']!= '' and searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Marks': searchopt['Marks']}, {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}}]})

            elif(searchopt['Subject']!=[] and searchopt['Keywords']!= '' and searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Keywords': {"$all": searchopt['Keywords']}}, {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}}]})

            elif(searchopt['Marks']!= '' and searchopt['Keywords']!= '' and searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({"$and": [{'Tags.Marks': searchopt['Marks']},
                {'Tags.Keywords': {"$all": searchopt['Keywords']}}, {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}}]})

            elif(searchopt['Subject']!=[] and searchopt['Marks']!= '' and searchopt['Keywords']!=[]):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Marks': searchopt['Marks']}, {'Tags.Keywords': {"$all": searchopt['Keywords']}}]})

            elif(searchopt['Subject']!=[] and searchopt['Marks']!= ''):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Marks': searchopt['Marks']}]})

            elif(searchopt['Marks']!= '' and searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({"$and": [
                {'Tags.Marks': searchopt['Marks']}, {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}}]})

            elif(searchopt['Subject']!=[]and searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}}]})

            elif(searchopt['Keywords']!=[] and searchopt['Subject']!=[]):
                res = col.find({"$and": [{'Tags.Subject': {'$all': searchopt['Subject']}},
                {'Tags.Keywords': {"$all": searchopt['Keywords']}}]})
            
            elif(searchopt['Keywords']!=[] and searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({"$and": [{'Tags.Keywords': {"$all": searchopt['Keywords']}},
                {'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}}]})

            elif(searchopt['Keywords']!=[] and searchopt['Marks']!= ''):
                res = col.find({"$and": [{'Tags.Marks': searchopt['Marks']},
                {'Tags.Keywords': {"$all": searchopt['Keywords']}}]})

            elif(searchopt['Subject']!=[]):
                res = col.find({'Tags.Subject': {'$all': searchopt['Subject']}})

            elif(searchopt['Bloom’s Taxonomy']!=[]):
                res = col.find({'Tags.Bloom’s Taxonomy': {"$all": searchopt['Bloom’s Taxonomy']}})

            elif(searchopt['Marks']!= ''):
                res = col.find({'Tags.Marks': searchopt['Marks']})
            
            elif(searchopt['Keywords']!=[]):
                res = col.find({'Tags.Keywords': {"$all": searchopt['Keywords']}})

            else:
                res = col.find()

            data = dumps(res)
            if (data is not None and data != '[]'):
                return data, 200
            else:
                return {'Message': 'Result Not Found'}, 400
        except Exception as e:
            #print(e)
            return {'Message': 'Invalid Token'}, 400


@app.route('/UserQuestions', methods=['POST'])
def UserQuestions():
    if request.method == 'POST':
        json = request.json
        result = []
        try:
            token = jwt.decode(json['token'], key=jwtSecret, algorithms=["HS256"])
            for i in collections[1:]:
                col = database[i]
                res = col.find({"Author": token['_id']})
                if res is not None:
                    [result.append(j)for j in res]
            if result is not None:
                #print(dumps(result))
                return dumps(result), 200
            else:
                return {'Message': 'Result Not Found'}, 400
        except Exception as e:
            print(e)
            return {'Message': 'Invalid Token'}, 400


@app.route('/Add', methods=['POST'])
def Add():
    if request.method == 'POST':
        json = request.json
        try:
            quest = []
            token = jwt.decode(json['token'], key=jwtSecret, algorithms=["HS256"])
            qttype = json['Type']
            col = database[qttype]
            res = col.aggregate([
            
                {"$match" : { "Tags.Subject" : json['Subject'] } },
                {"$group": {
                    "_id": "$Question"
                }}
            
            ])
            x = dumps(res)
            [quest.append(j['_id']) for j in Json.loads(x)]
            quest.sort()
            print(quest)
            if(len(quest)>1):
                checksim = checkSim(json['Question'],quest)
                if(checksim):
                    return {'Message': "Similar Question Already Exist in Database"}, 400
            if(qttype == collections[1] or qttype == collections[2]): # MCQ/MCA
                col = database[qttype]
                res = col.insert_one({
                    "Type": qttype,
                    "Question": json['Question'],
                    "ImageQuestion": json['ImageQuestion'],
                    "Options": json['Options'],
                    "Answers": json['Answers'],
                    "Tags": {
                        "Subject": json['Subject'],
                        "Marks": json['Marks'],
                        "Keywords": json['Keywords'],
                        "Bloom’s Taxonomy": json['Bloom’s Taxonomy'] or []
                    },
                    "Author": token['_id']
                })
            elif(qttype == collections[3]): #Theory
                col = database[qttype]
                res = col.insert_one({
                    "Type": qttype,
                    "Question": json['Question'],
                    "ImageQuestion": json['ImageQuestion'],
                    "Options":[],
                    "Answers":[],
                    "Tags": {
                        "Subject": json['Subject'],
                        "Marks": json['Marks'],
                        "Keywords": json['Keywords'],
                        "Bloom’s Taxonomy": json['Bloom’s Taxonomy'] or []
                    },
                    "Author": token['_id']
                })
            elif(qttype == collections[4] or qttype== collections[5]):  #T/F FIB
                col = database[qttype]
                res = col.insert_one({
                    "Type": qttype,
                    "Question": json['Question'],
                    "ImageQuestion": json['ImageQuestion'],
                    "Options":[],
                    "Answers": json['Answers'],
                    "Tags": {
                        "Subject": json['Subject'],
                        "Marks": json['Marks'],
                        "Keywords": json['Keywords'],
                        "Bloom’s Taxonomy": json['Bloom’s Taxonomy'] or []
                    },
                    "Author": token['_id']
                })
    
            if res is not None:
                return {'Message': 'Data Inserted'}, 200
            else:
                return {'Message': 'Data Not Inserted'}, 400
        except Exception as e:
            print(e)
            return {'Message': 'Invalid Token'}, 400


@app.route('/Edit', methods=['POST'])
def Edit():
    if request.method == 'POST':
        json = request.json
        try:
            token = jwt.decode(json['token'], key=jwtSecret, algorithms=["HS256"])
            qttype = json['Type']

            if(qttype == collections[1] or qttype == collections[2]): # MCQ/MCA
                col = database[qttype]
                res = col.update_one({"_id":ObjectId(json['Id'])},{
                    "Type": qttype,
                    "Question": json['Question'],
                    "ImageQuestion": json['ImageQuestion'],
                    "Options": json['Options'],
                    "Answers": json['Answers'],
                    "Tags": {
                        "Subject": json['Subject'],
                        "Marks": json['Marks'],
                        "Keywords": json['Keywords'],
                        "Bloom’s Taxonomy": json['Bloom’s Taxonomy'] or []
                    },
                    "Author": token['_id']
                })
            elif(qttype == collections[3]): #Theory
                col = database[qttype]
                res = col.update_one({"_id":ObjectId(json['Id'])},{
                    "Type": qttype,
                    "Question": json['Question'],
                    "ImageQuestion": json['ImageQuestion'],
                    "Tags": {
                        "Subject": json['Subject'],
                        "Marks": json['Marks'],
                        "Keywords": json['Keywords'],
                        "Bloom’s Taxonomy": json['Bloom’s Taxonomy'] or []
                    },
                    "Author": token['_id']
                })
            elif(qttype == collections[4] or qttype== collections[5]):  #T/F FIB
                col = database[qttype]
                res = col.update_one({"_id":ObjectId(json['Id'])},{
                    "Type": qttype,
                    "Question": json['Question'],
                    "ImageQuestion": json['ImageQuestion'],
                    "Answers": json['Answers'],
                    "Tags": {
                        "Subject": json['Subject'],
                        "Marks": json['Marks'],
                        "Keywords": json['Keywords'],
                        "Bloom’s Taxonomy": json['Bloom’s Taxonomy'] or []
                    },
                    "Author": token['_id']
                })
    
            if res is not None:
                return {'Message': 'Data Inserted'}, 200
            else:
                return {'Message': 'Data Not Inserted'}, 400
        except Exception as e:
            #print(e)
            return {'Message': 'Invalid Token'}, 400


def checkSim(quest,listques):
    extra_stop = ['Explain','Why', 'What', 'Describe', 'How','brief','short','Write','note']
    new_StopWords = stopwords.words('english') + extra_stop

    #print(new_StopWords)

    """Sentence Tokenizing"""

    from nltk.tokenize import sent_tokenize

    data = ". ".join(listques)

    data2 =  sent_tokenize(data)

    #print(data2)

    """Tokenizing in words and Making a dictionary"""

    gen_docs = [[w.lower() for w in word_tokenize(text)] 
                for text in data2]
    #print(gen_docs)

    dictionary = gensim.corpora.Dictionary(gen_docs)
    #print(dictionary.token2id)

    """Making Corpus(Bag of words)"""

    corpus = [dictionary.doc2bow(gen_doc) for gen_doc in gen_docs]
    #print(corpus)

    """TFID"""

    tf_idf = gensim.models.TfidfModel(corpus)
    #for doc in tf_idf[corpus]:
        #print([[dictionary[id], np.around(freq, decimals=2)] for id, freq in doc])

    """Creating similarity measure object"""
    #path = os.getcwd()
    #print(path)
    # building the index
    sims = gensim.similarities.Similarity(None, tf_idf[corpus], num_features=len(dictionary))

    """Query question and its preprocessing"""

    query_quest = quest
    query_quest_token = [w.lower() for w in word_tokenize(query_quest)]
    query_quest_bow = dictionary.doc2bow(query_quest_token)

    """Checking similarity"""

    # perform a similarity query against the corpus
    query_quest_tf_idf = tf_idf[query_quest_bow]
    #print(document_number, document_similarity)
    #print('Comparing Result:', sims[query_quest_tf_idf])
    if(max(sims[query_quest_tf_idf])>=0.7):
        return True
    else:
        return False





app.run(host='0.0.0.0',port=environ.get("PORT", 5000),debug=True)
#app.run(debug=False)


# pip install Flask 'pymongo[srv]' pyjwt[crypto] passlib flask_cors dnspython
