"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[7080],{3905:function(e,t,n){n.d(t,{Zo:function(){return c},kt:function(){return f}});var o=n(67294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);t&&(o=o.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,o)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,o,r=function(e,t){if(null==e)return{};var n,o,r={},i=Object.keys(e);for(o=0;o<i.length;o++)n=i[o],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(o=0;o<i.length;o++)n=i[o],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var s=o.createContext({}),u=function(e){var t=o.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},c=function(e){var t=u(e.components);return o.createElement(s.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return o.createElement(o.Fragment,{},t)}},p=o.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),p=u(n),f=r,h=p["".concat(s,".").concat(f)]||p[f]||d[f]||i;return n?o.createElement(h,a(a({ref:t},c),{},{components:n})):o.createElement(h,a({ref:t},c))}));function f(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,a=new Array(i);a[0]=p;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:r,a[1]=l;for(var u=2;u<i;u++)a[u]=n[u];return o.createElement.apply(null,a)}return o.createElement.apply(null,n)}p.displayName="MDXCreateElement"},11933:function(e,t,n){n.r(t),n.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return u},toc:function(){return c},default:function(){return p}});var o=n(87462),r=n(63366),i=(n(67294),n(3905)),a=["components"],l={sidebar_position:2},s=void 0,u={unversionedId:"contributing",id:"contributing",isDocsHomePage:!1,title:"contributing",description:"You make something cool and want to share? Great! Saves us all time! If you want to save some time, copy the Template.lua folder at the root of this library!",source:"@site/docs/contributing.md",sourceDirName:".",slug:"/contributing",permalink:"/synthetic/docs/contributing",editUrl:"https://github.com/nightcycle/synthetic/edit/master/docs/contributing.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"defaultSidebar",previous:{title:"intro",permalink:"/synthetic/docs/intro"},next:{title:"future",permalink:"/synthetic/docs/future"}},c=[{value:"Guidlines",id:"guidlines",children:[{value:"I Don&#39;t Care If the Backend is Messy",id:"i-dont-care-if-the-backend-is-messy",children:[],level:3},{value:"Label Your GuiObjects",id:"label-your-guiobjects",children:[],level:3},{value:"All Public Properties, BindableEvents, and BindableFunctions are PascalCase",id:"all-public-properties-bindableevents-and-bindablefunctions-are-pascalcase",children:[],level:3},{value:"Use Util.cornerRadius for non-circular UICorners",id:"use-utilcornerradius-for-non-circular-uicorners",children:[],level:3},{value:"Content is where you leave room for miscellaneous GuiObject Additions",id:"content-is-where-you-leave-room-for-miscellaneous-guiobject-additions",children:[],level:3},{value:"Inputs &amp; Values",id:"inputs--values",children:[],level:3},{value:"Use Typography for Text, UICorner&#39;s, and Padding when possible",id:"use-typography-for-text-uicorners-and-padding-when-possible",children:[],level:3},{value:"I&#39;m Not Super Strict on Use of Material Design",id:"im-not-super-strict-on-use-of-material-design",children:[],level:3}],level:2},{value:"Just Fork this File",id:"just-fork-this-file",children:[],level:2}],d={toc:c};function p(e){var t=e.components,n=(0,r.Z)(e,a);return(0,i.kt)("wrapper",(0,o.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("p",null,"You make something cool and want to share? Great! Saves us all time! If you want to save some time, copy the Template.lua folder at the root of this library!"),(0,i.kt)("h2",{id:"guidlines"},"Guidlines"),(0,i.kt)("p",null,"If you already wrote it and it doesn't match that's fine, I can just add it myself. Ideally though here's how custom components will work"),(0,i.kt)("h3",{id:"i-dont-care-if-the-backend-is-messy"},"I Don't Care If the Backend is Messy"),(0,i.kt)("p",null,"I honestly don't care if your code's messy. Now don't get me wrong, if you can make your code readable and elegant go for it. But if you're worried about sending in some cool component you built just because I'll look down on you for it, don't worry about it. Just don't obfuscate it or anything lol."),(0,i.kt)("h3",{id:"label-your-guiobjects"},"Label Your GuiObjects"),(0,i.kt)("p",null,"If you make an element composed of multiple GuiObjects, please give them unique names"),(0,i.kt)("h3",{id:"all-public-properties-bindableevents-and-bindablefunctions-are-pascalcase"},"All Public Properties, BindableEvents, and BindableFunctions are PascalCase"),(0,i.kt)("p",null,"That means the first letter of each word is capitalized and there aren't any underscores used."),(0,i.kt)("h3",{id:"use-utilcornerradius-for-non-circular-uicorners"},"Use Util.cornerRadius for non-circular UICorners"),(0,i.kt)("p",null,"If you must deviate from it, at least use it within a Computed FusionState to adjust accordingly."),(0,i.kt)("h3",{id:"content-is-where-you-leave-room-for-miscellaneous-guiobject-additions"},"Content is where you leave room for miscellaneous GuiObject Additions"),(0,i.kt)("p",null,"If you're making a component meant to hold other GuiObjects that aren't explicitly created by that component, then name the holding frame \"Content\". An example of this would be like a ScrollingFrame."),(0,i.kt)("h3",{id:"inputs--values"},"Inputs & Values"),(0,i.kt)("p",null,'User inputs should always be provided with an "Input" State, and the output should be a read-only "Value" state. It\'s mostly arbitrary, but various components need that kind of separation and I think this naming convention works okay.'),(0,i.kt)("h3",{id:"use-typography-for-text-uicorners-and-padding-when-possible"},"Use Typography for Text, UICorner's, and Padding when possible"),(0,i.kt)("p",null,"Whether you like them or not, Typography currently shapes much of the current UI scaling, so integrating the custom class into your components will allow them to fit in better. Don't use TextScaling for any text elements either."),(0,i.kt)("h3",{id:"im-not-super-strict-on-use-of-material-design"},"I'm Not Super Strict on Use of Material Design"),(0,i.kt)("p",null,"The reality is Material was designed for webpages, not videogames. I understand that we can't always get an exact translation. So long as the UI fits the general vibe we've got going here I'm fine with that."),(0,i.kt)("h2",{id:"just-fork-this-file"},"Just Fork this File"),(0,i.kt)("p",null,"If you could include any links / gifs of the final UI demo that would certainly be appreciated. Make sure you put your new UI Component under the Template folder. If you think it's a worth addition to a lower level one let me know, but for now I'm just going to assume everyone's making Template level stuff."))}p.isMDXComponent=!0}}]);