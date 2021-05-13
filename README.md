# ARGen
Create classes and code to simplify insertion of ActiveRecord into a Xojo project


//Copyright (c) 2021 Underwriters Technologies   www.undtec.com

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

# Modifications

- Version (almost) without plugins, references to Einhugur WindowSplitter removed, instead [imSplitter](https://github.com/oleman108/imSplitter) (currently MIT license) is used. 
MBS plugins not used by default, but if you have a license for MBS plugins, you can set the value of the useMBS constant 
in the modGlobals module from the default value of 'false' to 'true'.
- build settings for Linux added
- tested on Linux (Ubuntu 20.04) and Windows 10 only (not very intense, but it starts, 
  connects to sqlite, generates project). 
If anyone would like to check if it compiles and works on macOS, please let me know, if it works or not.
