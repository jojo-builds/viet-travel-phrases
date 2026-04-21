import { useEffect, useState } from 'react';
import { Dimensions, Keyboard, Platform } from 'react-native';

export function useKeyboardInset() {
  const [keyboardInset, setKeyboardInset] = useState(0);

  useEffect(() => {
    const windowHeight = () => Dimensions.get('window').height;

    const handleFrameChange = (event: { endCoordinates?: { height?: number; screenY?: number } }) => {
      const endCoordinates = event.endCoordinates;

      if (!endCoordinates) {
        setKeyboardInset(0);
        return;
      }

      if (typeof endCoordinates.screenY === 'number') {
        setKeyboardInset(Math.max(windowHeight() - endCoordinates.screenY, 0));
        return;
      }

      if (typeof endCoordinates.height === 'number') {
        setKeyboardInset(endCoordinates.height);
      }
    };

    const changeEvent = Platform.OS === 'ios' ? 'keyboardWillChangeFrame' : 'keyboardDidShow';
    const hideEvent = Platform.OS === 'ios' ? 'keyboardWillHide' : 'keyboardDidHide';

    const changeSub = Keyboard.addListener(changeEvent, handleFrameChange);
    const hideSub = Keyboard.addListener(hideEvent, () => setKeyboardInset(0));

    return () => {
      changeSub.remove();
      hideSub.remove();
    };
  }, []);

  return keyboardInset;
}
