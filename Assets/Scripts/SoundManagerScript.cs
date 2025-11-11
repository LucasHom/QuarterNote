using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManagerScript : MonoBehaviour
{
    public GameObject metronome;
    public GameObject drumLoop;
    private float delaySeconds = 2.0f; // duration for spawned notes to hit the bar
    private float currentTime = 0;
    private bool musicStarted = false;
    public bool shouldMusicPlay = false;
    private bool metronomeRunning = false;
    private List<GameObject> trackList;
    private GameObject currentTrack;
    private int currentTrackIndex = 0;

    // Start is called before the first frame update
    void Start()
    {
        trackList = new List<GameObject>() { drumLoop };
        // IDK how to sync this lol
        // StartTrack(metronome);
    }

    // Update is called once per frame
    void Update()
    {
        if (shouldMusicPlay)
        {
            if (!metronomeRunning)
            {
                metronomeRunning = true;
                StartTrack(metronome);
            }
            currentTime += Time.deltaTime;
            if (currentTime > delaySeconds && !musicStarted) // can add like a record button to activate as well
            {
                musicStarted = true;
                StopTrack(); // stop metronome
                StartTrack(trackList[currentTrackIndex]);
            }
        }
        else
        {
            currentTime = 0.0f;
            musicStarted = false;
            StopTrack();
        }
    }

    void StartTrack(GameObject track)
    {
        currentTrack = Instantiate(track, transform.position, transform.rotation);
        currentTrack.GetComponent<AudioSource>().mute = false;
    }
    
    void StopTrack()
    {
        if (currentTrack != null)
        {
            currentTrack.GetComponent<AudioSource>().mute = true; 
            metronome.GetComponent<AudioSource>().mute = true;
        }
    }
}
