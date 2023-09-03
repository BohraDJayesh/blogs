document.addEventListener('DOMContentLoaded', function() {
    // Get references to all GIF images
    const gifs = document.querySelectorAll('img[id^="gif"]');
  
    // Function to play GIF forwards
    function playForwards(gif) {
      gif.play();
    }
  
    // Function to play GIF in reverse
    function playReverse(gif) {
      gif.playbackRate = -1;
      gif.play();
    }
  
    // Attach event listeners to each GIF
    gifs.forEach((gif) => {
      gif.addEventListener('mouseover', () => {
        playForwards(gif);
      });
  
      gif.addEventListener('mouseout', () => {
        playReverse(gif);
      });
  
      // Pause the GIF when it reaches the end
      gif.addEventListener('ended', () => {
        gif.pause();
      });
    });
  });
  