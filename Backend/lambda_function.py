import boto3
import urllib.request
import io
import base64
import json
from botocore.vendored import requests

def lambda_handler(event, context):

    client = boto3.client("rekognition")

    base64_string = event['imageBase64']
    employeeID = event['employeeUUID']
    score = 0

    imgdata = base64.b64decode(base64_string)
    f = io.BytesIO(imgdata)

    response = client.detect_faces(Image = {"Bytes": f.read()},  Attributes=['ALL'])
    respList = response['FaceDetails'][0]['Emotions']

    jScore, lst = calcJScore(respList)

    defaultDict = {
        "id": employeeID,
        "crashScore" : jScore,
        "emotions" : {
            "scoreCount" : "1",
            "totalScore" : jScore
        },
        "userId" : "CAKESS"
    }

    #pull scoreCount and totalScore from FB through rest
    getReq = requests.get("https://nicetry.firebaseio.com/users/"+employeeID+".json")
    print(getReq.text)
    if getReq.text == "null":
        print("yes")
        putResp = requests.put("https://nicetry.firebaseio.com/users/"+employeeID+".json",json=defaultDict)
        print("Put Response is ", putResp)
    else:
        respList = response['FaceDetails'][0]['Emotions']
        emotionScore, lst = calcScore(respList)

    #pull scoreCount and totalScore from FB through rest
        resp = requests.get("https://nicetry.firebaseio.com/users/dsdw321ddd22ds221.json")
        respDict = json.loads(resp.text)

        scoreCount, totalScore = respDict['emotions'].values()

    #increment scoreCount and add current score to totalScore
        scoreCount += 1
        totalScore += emotionScore

    #update in database with the put request
        payload = {
        "scoreCount": scoreCount,
        "totalScore": totalScore,
        }

        respDict["emotions"]["scoreCount"] = scoreCount
        respDict["emotions"]["totalScore"] = totalScore

    # calculate average
        avg = totalScore/scoreCount if scoreCount != 0 else 0
        respDict["crashScore"] = avg

    # send response for update
        putResp = requests.put("https://nicetry.firebaseio.com/users/dsdw3e21ddd22ds221.json", json=respDict)
        print("Put Response is ", putResp)

    #update crashScore in database with put request
#     payload = {

# 		"userId": employeeID,
# 		"crashScore": score
#     }

    #putReq = requests.put("https://nicetry.firebaseio.com/users/dsdw321ddd22ds221.json", json=payload)

    #getReq = requests.get("https://nicetry.firebaseio.com/users/dsdw321ddd22ds221/emotions.json")

        getReq = requests.get("https://nicetry.firebaseio.com/users/"+employeeID+".json")
        print(getReq.text)
        if getReq.text == "null":
            print("yes")
            putResp = requests.put("https://nicetry.firebaseio.com/users/"+employeeID+".json", json=respDict)
            print("Put Response is ", putResp)
        else:
            print(int(json.loads(getReq.text)["crashScore"])+3)
    #print("hley")
    ##print(base64_string)
    ##print(response['FaceDetails'][0]["Emotions"])

    # use if there is no face in the image
    # if len(response['FaceDetails']) == 0:


        respList = response['FaceDetails'][0]['Emotions']
        emotionScore, lst = calcScore(respList)

    #pull scoreCount and totalScore from FB through rest
        resp = requests.get("https://nicetry.firebaseio.com/users/dsdw321ddd22ds221.json")
        respDict = json.loads(resp.text)

        scoreCount, totalScore = respDict['emotions'].values()

    #increment scoreCount and add current score to totalScore
        scoreCount += 1
        totalScore += emotionScore

    #update in database with the put request
        payload = {
            "scoreCount": scoreCount,
            "totalScore": totalScore,
        }

        respDict["emotions"]["scoreCount"] = scoreCount
        respDict["emotions"]["totalScore"] = totalScore

    # calculate average
        avg = totalScore/scoreCount if scoreCount != 0 else 0
        respDict["crashScore"] = avg

    # send response for update
        putResp = requests.put("https://nicetry.firebaseio.com/users/dsdw3e21ddd22ds221.json", json=respDict)
        print("Put Response is ", putResp)

    #update crashScore in database with put request
#     payload = {

# 		"userId": employeeID,
# 		"crashScore": score
#     }

    #putReq = requests.put("https://nicetry.firebaseio.com/users/dsdw321ddd22ds221.json", json=payload)

    #getReq = requests.get("https://nicetry.firebaseio.com/users/dsdw321ddd22ds221/emotions.json")

        getReq = requests.get("https://nicetry.firebaseio.com/users/"+employeeID+".json")
        print(getReq.text)
        if getReq.text == "null":
            print("yes")
            putResp = requests.put("https://nicetry.firebaseio.com/users/"+employeeID+".json", json=respDict)
            print("Put Response is ", putResp)
        else:
            print(int(json.loads(getReq.text)["crashScore"])+3)


    return {
        #should it return status?
        'data': lst,
        'givenUUID': employeeID
    }

def calcScore(emotionResponse):
    score = 0

    lst = sorted(emotionResponse, key=lambda x: x['Confidence'], reverse=True)

    #get score from current photo
    typeString = lst[0]["Type"]
    if typeString == "HAPPY":
        score = 0

    elif typeString == "UNKNOWN":
        score = 0

    elif typeString == "CALM":
        score = 0

    elif typeString == "SAD":
        score = 4

    elif typeString == "SURPRISED":
        score = 6

    elif typeString == "DISGUSTED":
        score = 6

    elif typeString == "CONFUSED":
        score = 8

    elif typeString == "ANGRY":
        score = 10

    return score, lst

def calcJScore(emotionResponse):
    score = 0


    #get score from current photo
    typeString = emotionResponse[0]["Type"]
    if typeString == "HAPPY":
        score = 0

    elif typeString == "UNKNOWN":
        score = 0

    elif typeString == "CALM":
        score = 0

    elif typeString == "SAD":
        score = 4

    elif typeString == "SURPRISED":
        score = 6

    elif typeString == "DISGUSTED":
        score = 6

    elif typeString == "CONFUSED":
        score = 8

    elif typeString == "ANGRY":
        score = 10

    return score, emotionResponse

# def calcRollingScore(emotionResponse):
#     rollingScore = 0

#     emotionWeights = {0, 0, 0, 0, 4, 6, 6, 8, 10}

#     for index, percent in enumerate(emotionResponse.values()):
#         rollingScore += emotionWeights[index] * percent

#     return rollingScore
