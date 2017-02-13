package fr.arnaud_nicolas.findacar.fragments;

import android.os.Bundle;
import android.preference.PreferenceFragment;
import fr.arnaud_nicolas.findacar.R;

public class SettingsFragments extends PreferenceFragment
{
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        addPreferencesFromResource(R.xml.preferences);
    }
}
