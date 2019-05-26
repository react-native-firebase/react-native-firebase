package io.invertase.firebase.database;

/*
 * Copyright (c) 2016-present Invertase Limited & Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this library except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


import android.content.Context;

import com.google.android.gms.tasks.Task;

import java.util.Map;

import io.invertase.firebase.common.UniversalFirebaseModule;

import static io.invertase.firebase.database.UniversalFirebaseDatabaseCommon.getDatabaseForApp;

public class UniversalFirebaseDatabaseReferenceModule extends UniversalFirebaseModule {

  UniversalFirebaseDatabaseReferenceModule(Context context, String serviceName) {
    super(context, serviceName);
  }

  Task<Void> set(String appName, String dbURL, String path, Object value) {
    return getDatabaseForApp(appName, dbURL)
      .getReference(path)
      .setValue(value);
  }

  Task<Void> update(String appName, String dbURL, String path, Map<String , Object> value) {
    return getDatabaseForApp(appName, dbURL)
      .getReference(path)
      .updateChildren(value);
  }

  Task<Void> setWithPriority(String appName, String dbURL, String path, Object value, Object priority) {
    return getDatabaseForApp(appName, dbURL)
      .getReference(path)
      .setValue(value, priority);
  }

  Task<Void> remove(String appName, String dbURL, String path) {
    return getDatabaseForApp(appName, dbURL)
      .getReference(path)
      .removeValue();
  }

  Task<Void> setPriority(String appName, String dbURL, String path, Object priority) {
    return getDatabaseForApp(appName, dbURL)
      .getReference(path)
      .setPriority(priority);
  }
}
