/*
 Copyright 2013 Esri
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#define MK_EXTERN       extern "C" __attribute__((visibility ("default")))
#else
#define MK_EXTERN       extern __attribute__((visibility ("default")))
#endif

#define MK_CLASS_AVAILABLE(_macIntro, _iphoneIntro) __attribute__((visibility("default"))) NS_CLASS_AVAILABLE(_macIntro, _iphoneIntro)

#define MK_CLASS_DEPRECATED(_macIntro,_macDep,_iphoneIntro,_iphoneDep) __attribute__((visibility("default"))) NS_DEPRECATED(_macIntro,_macDep,_iphoneIntro,_iphoneDep)

