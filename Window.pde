import java.util.*;
import ddf.minim.*;
import com.onformative.yahooweather.*;

ArrayList<Snowflake> snows;
YahooWeather weather;
int updateIntervallMillis = 30000; 

int num = 6; 
Spring[] dots = new Spring[num]; 
Raindrop[] drops;     // An array of drop objects
int totalDrops = 0;   // totalDrops
Timer timer;          // One timer object

//birds
Bird birdy1, birdy2;

// perlin noise
float xt1 = 100.0;
float yt1 = 10.0;
float xt2 = 100.0;
float yt2 = 10.0;
float increment1 = 0.02; // controls distance between numbers
float increment2 = 0.05; // controls distance between numbers


// sound 
AudioPlayer play_rain, play_bird, play_wind;
Minim minim;

boolean rainy=false;
boolean snowy=false;
boolean clear=true;
boolean sunny=false;
boolean nyc=true;
boolean isday=false;

void setup()
{
  size(1000, 650);
  noStroke(); 
  //initialize weather variable for NewYork   2459115

  weather = new YahooWeather(this, 2459115, "c", updateIntervallMillis);
  nyc=true;
  isday=false;
  
  // initialize positions for buttons
  dots[0] = new Spring(120, 550, 100, 0.98, 8.0, 0.1, dots, 0); 
  dots[1] = new Spring(120+width/4, 550, 100, 0.98, 8.0, 0.1, dots, 1); 
  dots[2] = new Spring(120+width/2, 550, 100, 0.98, 8.0, 0.1, dots, 2);
  dots[3] = new Spring(120+(width/4)*3, 550, 100, 0.98, 8.0, 0.1, dots, 3);  
  // new york city or custom
  dots[4] = new Spring(width, height-200, 50, 0.98, 8.0, 0.1, dots, 4);
  // day or night 
  dots[5] = new Spring(0, height-200, 50, 0.98, 8.0, 0.1, dots, 5); 
 
  // inititalize raindrops
  drops = new Raindrop[1000];    
  
 // set timer and start it
  timer = new Timer(300);      // timer goes off every 2 seconds
  timer.start();               // start the timer
  
  // initialize snow
  snows = new ArrayList<Snowflake>();  
  // loading snow
   for (int i = 0; i < 1; i++) {
    snows.add(new Snowflake());
    }
  
  //Birds
   birdy1 = new Bird(150,50,76); 
   birdy2 = new Bird(76, 110, 150); 
 
  // sound
 
  minim=new Minim(this);
  smooth();
 
  
  play_bird=minim.loadFile("sounds/birds.mp3",2048); 
  play_bird.loop();  
  if (isday && clear) 
  {
  play_bird.play();
  }
  
  play_wind=minim.loadFile("sounds/wind.wav",2048); 
  play_wind.loop();  
  play_wind.pause();  
  
  if (isday==false && play_wind.isPlaying()==false) {play_wind.play();
  play_bird.pause();
  }
  
  play_rain=minim.loadFile("sounds/rainy.mp3",2048); 
  play_rain.loop();  
  play_rain.pause();  
  
}

void draw() 
{
  
  if(isday)
  {background(127,220,255);} 
  else
  {background(0);
  if(play_wind.isPlaying()==false) play_wind.play();
  play_bird.pause();
  } 
  
  //Weather
 if (nyc)
 { 
   weather.update();
  textSize(20);
  text("City: "+weather.getCityName(), 100, 100);
  text("Weather: "+weather.getWeatherCondition(), 100, 120);
  text("WindTemperature: "+weather.getWindTemperature()+" °C",100,140);
  text("WindDirection: "+weather.getWindDirection(), 100, 160);
  text("WindSpeed: "+weather.getWindSpeed()+"km/h", 100, 180);
  text("Sunrise: "+weather.getSunrise()+" Sunset: "+weather.getSunset(), 100, 200);
  if(weather.getWindSpeed()>2 && play_wind.isPlaying()==false)
    play_wind.play();
  
  }
  else {
  //rain
  if(isday && sunny){
    noStroke();
    fill(255, 255, 0);
    ellipse(400, 126, 80, 80);
  }

  if (rainy){
    if(play_rain.isPlaying()==false) play_rain.play();
    if(play_bird.isPlaying()) play_bird.pause();
    
  // Check the timer
  if (timer.isFinished()) {
    // Deal with raindrops
    // Initialize one drop
    drops[totalDrops] = new Raindrop();
    // Increment totalDrops
    totalDrops ++ ;
    println(totalDrops);
    // If we hit the end of the array
    if (totalDrops >= drops.length) {
      totalDrops = 0; // Start over
    }
    timer.start();
  }
  
  // Move and display all drops
  for (int i = 0; i < totalDrops; i++ ) {
    drops[i].move();
    drops[i].display();
    }
  }
  if (snowy){
 
      play_rain.pause();  
      play_bird.pause();
      
  if ((frameCount % 15) == 0) {
    snows.add(new Snowflake());
  }   
  //lights();  //Only for 3D
  for (Snowflake s: snows) {
    s.display();
  }
  for(int i = 0; i < snows.size(); i++){
    Snowflake s = snows.get(i);
    if(s.death)
      snows.remove(s);
    }
  }
  //birds
 if (isday && clear)
 {
  if(play_bird.isPlaying()==false) 
  play_bird.play();
  
 float x1 = birdy1.x;
 float y1 = birdy1.y;
 float x2 = birdy2.x;
 float y2 = birdy2.y;
 
  // check for hit
  birdy2.hitTest(birdy1);
   
  // add noise
  x1 = width * noise(xt1);
  y1 = height * noise(yt1);
  x2 = width * noise(xt2);
  y2 = height * noise(yt2);
    
  // display birds
  birdy1.display(x1, y1);
  birdy2.display(x2, y2);
    
  // increment timers
  xt1 += increment1;
  yt1 += increment1;
  xt2 += increment2;
  yt2 += increment2;
  }
  }
  
  //Window
  fill(160,160,160); 
  strokeWeight(0);
  rect(((width/2)-10),0,20,height-200);
  rect(0,0,20,height-200);
  rect(width-20,0,20,height-200);
  rect(0,0,width,20);
  rect(0,((height/2)-10),width,20);
  rect(0,height-200,width,20);
  // Wall
  fill(255,230,230);
  rect(0,height-180,width,height);  
  // Dots
  for (int i = 0; i < num; i++) { 
    dots[i].update(); 
    dots[i].display(); 
  } 
  
  textSize(30);
  fill(0, 102, 153, 204);
  text("Clear", 80, 630, -30);
  text("Rain", 84+width/4, 630, -30);
  text("Sun", 91+width/2, 630, -30);
  text("Snow", 80+(width/4)*3, 630, -30);
}

void mousePressed() 
{  for (int i = 0; i < num; i++) { 
    dots[i].pressed();
    }
}

void mouseReleased() 
{  
//  println(mouseX,mouseY);
 
 //DOTS
  for (int i=0; i<num; i++) { 
    dots[i].released(); 
  } 
 // to change weather
  if(mouseY>height-180){
    nyc=false;
    if(mouseX<width/4){
      println("clear");
      clear=true;
      rainy=false;
      snowy=false;
      play_bird.play();   
      play_rain.pause();
     
}
    else if(mouseX<width/2){
      println("rain");
      rainy=true;
      clear=false;
      snowy=false;
    }
    else if(mouseX<(width/4)*3){
      println("sun");
      if(sunny) sunny=false;
      else sunny=true;
      
    }
    else if(mouseX<width){
      println("snow");
      snowy=true;
      clear=false;
      rainy=false;
      play_bird.pause();
      play_rain.pause();
    }
    
  }
  // to toggle nyc and custom weather
  if(mouseX<25 && mouseY< 500 && mouseY> 400)
  { 
    if (nyc) nyc=false;
    else  nyc=true;
  }
  // to toggle between day and night
  if(mouseX>width-25 && mouseY< 500 && mouseY> 400)
  { nyc=false;
    if (isday) {isday=false;
  }
    else  {
      isday=true;
    }
  }
}


