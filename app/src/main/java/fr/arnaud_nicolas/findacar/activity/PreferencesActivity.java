package fr.arnaud_nicolas.findacar.activity;

import android.os.Bundle;
import fr.arnaud_nicolas.findacar.fragments.SettingsFragments;
import fr.arnaud_nicolas.findacar.tools.AppCompatPreferenceActivity;

public class PreferencesActivity extends AppCompatPreferenceActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getFragmentManager().beginTransaction()
                .replace(android.R.id.content, new SettingsFragments()).commit();
    }
}
