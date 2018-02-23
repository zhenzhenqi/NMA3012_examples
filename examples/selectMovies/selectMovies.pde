//import ddf.minim.*;
import processing.video.*; 

int maxNum = 4; //set total number of movies to be loaded. when total number of movies in data folder changes, this is the only number that needs to be reset
Movie [] myMovies = new Movie[maxNum]; //an array of totally 4 movies
int myMoviesIndex; // index of movie currently playing
int[] moviesPaused = new int[maxNum-1]; //a list of movies paused, based on which one is playing


void setup()
{
  size(620, 320);
  //load in all movies
  for (int i = 0; i < myMovies.length; i ++ ) {
    myMovies[i] = new Movie(this, "flower" + i + ".mp4" );
  }  
  println("length of movie array is:"+myMovies.length);
  
  myMoviesIndex=0; //by default, indicate the first movie to play
  myMovies[0].loop(); //and play it on loop
}


void movieEvent(Movie movie) {
  movie.read();
}

void draw() {
  image(myMovies[myMoviesIndex], 0, 0); //displays the selected channel only
}



//each time when a new key is pressed, first check if the selected channel is already playing. if yes, do nothing.
//if a new channel is selected, switch the movie array index to the newly selected channel. 
//make sure only the selected moive is on loop, and all the rest of the movies are on pause.
//when total number of movie changes, keyPressed function needs to be manually added/deleted accordingly.
void keyPressed(){
     if (key == '0') {
       if(myMoviesIndex!=0){
          myMoviesIndex=0;
          playPause();
       }
      }else if (key == '1') {
       if(myMoviesIndex!=1){
          myMoviesIndex=1;
          playPause();
       }
      }else if (key == '2') {
       if(myMoviesIndex!=2){
          myMoviesIndex=2;
          playPause();
       }
      }else if (key == '3') {
       if(myMoviesIndex!=3){
          myMoviesIndex=3;
          playPause();
       }
      }else{
      //do nothing if an unmapped key is clicked by accident
      }
}


//this function double checks that only the selected video is on loop and all other videos in the movie array are on pause.
//this function should be called every time when channel is switched. 
void playPause(){
  myMovies[myMoviesIndex].loop();

  for(int i=0; i<myMovies.length; i++){
    if(i!=myMoviesIndex){
      myMovies[i].pause();
    }
  }

}


