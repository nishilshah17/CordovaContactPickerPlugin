package com.monmouth.contactpicker;

import android.app.Activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.*;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;

public class ContactPicker extends CordovaPlugin {

    private Context context;
    private CallbackContext callbackContext;

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext)
    {
        this.callbackContext = callbackContext;
        this.context = cordova.getActivity().getApplicationContext();

        int CHOOSE_CONTACT = 1;

        if(action.equals("pickcontact")) {
            Intent intent = new Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI);
            cordova.startActivityForResult(this, intent, CHOOSE_CONTACT);
            PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
            r.setKeepCallback(true);
            callbackContext.sendPluginResult(r);
            return true;
        }

        return false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {

            Uri contactData = data.getData();
            String cID = contactData.getLastPathSegment();
            ContentResolver resolver = context.getContentResolver();
            Cursor c =  resolver.query( ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                    null,
                    ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = " + cID,
                    null,
                    null);

            final ArrayList<String> phonesList = new ArrayList<String>();

            if (c.moveToFirst()) {
                    String contactId = c.getString(c.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID));
                    String name = c.getString(c.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME));
                    String phoneNumber = "";
                    do {
                        String phone = c.getString(c.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DATA));
                        phonesList.add(phone);
                    } while (c.moveToNext());

                    if(phonesList.size() == 0) {
                        Toast.makeText(this.context, "No Phone Number associated with this Contact.", Toast.LENGTH_LONG).show();
                    }else if(phonesList.size() == 1) {
                         phoneNumber = phonesList.get(0);
                    }else{

                        final String[] phonesArr = new String[phonesList.size()];
                        for(int i = 0; i < phonesList.size(); i++){phonesArr[i] = phonesList.get(i);}
                        AlertDialog dialog = new AlertDialog.Builder(this).create();
                            dialog.setTitle("Select Phone Number");
                            dialog.setItems(phonesArr,
                                new DialogInterface.onClickListener() {
                                    public void onClick(DialogInterfce dialog, int which) {
                                        phoneNumber = phonesArr[which];
                                    }
                            });

                        dialog.show();
                    }

                try {
                    JSONObject contact = new JSONObject();
                    contact.put("contactId", contactId);
                    contact.put("displayName", name);
                    contact.put("phoneNumber", phoneNumber);
                    callbackContext.success(contact);
                } catch (Exception e) {
                    callbackContext.error("Parsing contact failed: " + e.getMessage());
                }

            } else {
                callbackContext.error("Contact was not available.");
            }

            c.close();

        } else if (resultCode == Activity.RESULT_CANCELED) {
            callbackContext.error("No contact was selected.");
        }
    }

}
