import googlemaps
from datetime import datetime
import html2text
from PIL import Image  # Automatically opens Image
import sys
import gmplot
from dotenv import load_dotenv
import os

load_dotenv()

class Maps:

    def __init__(self):
        self.key = os.getenv('MY_API_KEY')
        self.client = googlemaps.Client(key=self.key)

    def getDirections(self, addr1, addr2, transportation_mode):
        f = open('../Data/directions.txt', "a")
        f.truncate(0)
        f.close()
        now = datetime.now()
        directions_result = self.client.directions(
            addr1, addr2, mode=transportation_mode, departure_time=now)
        f = open("../data/directions.txt", "a")
        f.write(addr1 + " " + "to" + " " + addr2 + "\n\n")
        for i in range(len(directions_result[0]['legs'][0]['steps'])):
            f.write(html2text.html2text(
                directions_result[0]['legs'][0]['steps'][i]['html_instructions'].replace('**', '')))

        gmaps = Maps()
        distance = gmaps.getDistance(addr1, addr2, transportation_mode)*0.621371 #0.621371 to convert km=>mi
        dist = str(distance)
        time = gmaps.getTime(addr1, addr2, transportation_mode)
        f.write("Total Distance: " + " " + dist + " " + "mi" + "\n")
        f.write("Total Duration: " + time)
        f.close()

    def getLocation(self, addr):
        location = self.client.find_place(input=addr, input_type="textquery", fields=[
                                          'place_id', 'formatted_address'])
        print(location['candidates'][0]['formatted_address'])

    def getPhoto(self, addr):
        location = self.client.find_place(input=addr, input_type="textquery", fields=[
                                          'place_id', 'formatted_address'])
        my_place_id = location['candidates'][0]['place_id']
        my_fields = ['name', 'formatted_phone_number', 'photo']
        place_details = self.client.place(
            place_id=my_place_id, fields=my_fields)
        if len(list(place_details['result'].items())) != 3:
            print('Photo does not exist, try a different location')
            sys.exit(1)

        photo_ref = place_details['result']['photos'][0]['photo_reference']
        raw_image = self.client.places_photo(
            photo_reference=photo_ref, max_width=400, max_height=400)
        f = open('../Data/{}.jpg'.format(addr1), 'wb')
        for chunk in raw_image:
            f.write(chunk)
        f.close()
        im = Image.open('../Data/{}.jpg'.format(addr1))
        im.show()

    def getGeocode(self, addr):
        geocode = self.client.geocode(addr)
        return geocode[0]['geometry']['location']
    
    def findRoutes(self, addr1, addr2):
        gmaps = Maps()
        geo1 = gmaps.getGeocode(addr1)
        geo2 = gmaps.getGeocode(addr2)
        routes = [geo1, geo2]
        r = self.client.nearest_roads(points=routes)
        print(r)

    def getDistance(self, addr1, addr2, Mode):
        distance = self.client.distance_matrix(addr1, addr2, mode=Mode)
        dist = distance['rows'][0]['elements'][0]['distance']['text']
        num = float("".join(filter(lambda d: str.isdigit(d) or d=='.', dist)))
        return num
    
    def getTime(self, addr1, addr2, Mode):
        time = self.client.distance_matrix(addr1, addr2, mode=Mode)
        tme = time['rows'][0]['elements'][0]['duration']['text']
        return tme

    def reverse(self, string):
        string = ' '.join(reversed(string.split(' ')))
        return string

    def getTimeZone(self, addr):
        timeZone = self.client.timezone(addr, language="eng")
        print(timeZone)

    def estimateArrival(self, addr1, addr2):
        #Starting
        print('Lets see if you will be able to arrive to the location on time.')
        origin = addr1, location = addr2
        arrivalTime = str(input('What time are you supposed to arrive at the location: (_ min(s) _ hour(s) _ day(s))')) 
        now = datetime.now() # Current time 
        
        

# Driver
if __name__ == "__main__":
    gmaps = Maps()
    #addr1 = str(input("Enter First Location: "))
    addr1 = '4 Pelham Ave, Edison NJ'
    #addr2 = str(input("Enter Second Location: "))
    addr2 = 'California'
    mode = 'driving'
    time = gmaps.getTime(addr1, addr2, mode) 
    time = gmaps.reverse(time)
    print(time)
    